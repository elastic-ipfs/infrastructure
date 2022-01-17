package test

import (
	"context"
	"fmt"
	"sort"
	"strings"
	"testing"

	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/iam"
	"github.com/gruntwork-io/terratest/modules/logger"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/client-go/kubernetes"
	"k8s.io/client-go/rest"
	metrics "k8s.io/metrics/pkg/client/clientset/versioned"
)

// Run this increasing timeout, ex: "go test -timeout 30m"
func TestTerraformKubeComponetsExample(t *testing.T) {
	awsRegion := "us-west-2"
	bitswapRoleName := "bitswap_peer_subsystem_role"
	ctx := context.TODO()
	cfg, err := config.LoadDefaultConfig(ctx)
	cfg.Region = awsRegion
	IAMClient := iam.NewFromConfig(cfg)

	if err != nil {
		panic("configuration error, " + err.Error())
	}

	terraformOptions := &terraform.Options{
		TerraformDir: "../example",
		Vars: map[string]interface{}{
			"region":  awsRegion,
			"profile": "nearform", // TODO: Change to oficial sandbox account
			"vpc": map[string]string{
				"name": "terratest-kube-ipfs-aws-peer-subsystem-vpc",
			},
			"cluster_version":          "1.21",
			"cluster_name":             "terratest-ipfs-peer-subsystem",
			"provider_ads_bucket_name": "terratest-ipfs-provider-ads",
			"config_bucket_name":       "terratest-config-bucket",
		},
	}

	sensitiveTerraformOptions := *terraformOptions
	sensitiveTerraformOptions.Logger = logger.Discard // https://github.com/gruntwork-io/terratest/issues/358

	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)

	config := &rest.Config{
		Host:        terraform.Output(t, &sensitiveTerraformOptions, "eks_host"),
		BearerToken: terraform.Output(t, &sensitiveTerraformOptions, "eks_token"),
		TLSClientConfig: rest.TLSClientConfig{
			CAData: []byte(terraform.Output(t, &sensitiveTerraformOptions, "eks_cluster_ca_certificate")),
		},
	}

	assertMetrics(config, t)
	assertRolesAndPolicies(t, terraformOptions, IAMClient, ctx, bitswapRoleName, awsRegion)
	assertServiceConnections(config, t, sensitiveTerraformOptions, bitswapRoleName)

}

func assertServiceConnections(config *rest.Config, t *testing.T, sensitiveTerraformOptions terraform.Options, bitswapRoleName string) {
	kubeclient, err := kubernetes.NewForConfig(config)
	if err != nil {
		panic(err)
	}

	serviceAccounts, err := kubeclient.CoreV1().ServiceAccounts(metav1.NamespaceDefault).List(context.TODO(), metav1.ListOptions{})
	if err != nil {
		panic(err)
	}

	sort.SliceStable(serviceAccounts.Items, func(i, j int) bool {
		return serviceAccounts.Items[i].CreationTimestamp.Before(&serviceAccounts.Items[j].CreationTimestamp)
	})

	iam_roles := terraform.OutputMap(t, &sensitiveTerraformOptions, "iam_roles")

	assert.Equal(t, 2, len(serviceAccounts.Items)) // 2 because there is also a "default" sa
	assert.Equal(t, "bitswap-irsa", serviceAccounts.Items[1].Name)
	assert.Equal(t, "default", serviceAccounts.Items[1].Namespace)
	assert.Equal(t, serviceAccounts.Items[1].Annotations["eks.amazonaws.com/role-arn"], iam_roles[bitswapRoleName])	
}

func assertMetrics(config *rest.Config, t *testing.T,) {
	metrics, err := metrics.NewForConfig(config)
	if err != nil {
		panic(err)
	}

	_, err = metrics.MetricsV1beta1().PodMetricses(metav1.NamespaceAll).List(context.TODO(), metav1.ListOptions{})
	if err != nil {
		// Usually: "Error: the server could not find the requested resource (get pods.metrics.k8s.io)" when there isn't Metrics Server available
		panic("Metric server error" + err.Error())
	}
	assert.Equal(t, err, nil)
}

func assertRolesAndPolicies(t *testing.T, terraformOptions *terraform.Options, IAMClient *iam.Client, ctx context.Context, bitswapRoleName string, awsRegion string) {
	role, err := IAMClient.GetRole(ctx, &iam.GetRoleInput{
		RoleName: &bitswapRoleName,

	})
	if err != nil {
		panic("GetRole error, " + err.Error())
	}

	bitswapRolePoliciesFromIAM, err := IAMClient.ListAttachedRolePolicies(ctx, &iam.ListAttachedRolePoliciesInput{
		RoleName: &bitswapRoleName,
	})
	if err != nil {
		panic("ListAttachedRolePolicies error, " + err.Error())
	}
	
	cluster_oidc_issuer_url := terraform.Output(t, terraformOptions, "cluster_oidc_issuer_url")
	splited_cluster_oidc_issuer_url := strings.SplitAfter(cluster_oidc_issuer_url, "/")

	assert.Equal(t, "example-config-peer-s3-bucket-policy-read", *bitswapRolePoliciesFromIAM.AttachedPolicies[0].PolicyName)
	assert.Contains(t, *role.Role.AssumeRolePolicyDocument, fmt.Sprintf("oidc.eks.%s.amazonaws.com", awsRegion))
	assert.Contains(t, *role.Role.AssumeRolePolicyDocument, "AssumeRoleWithWebIdentity")
	assert.Contains(t, *role.Role.AssumeRolePolicyDocument, splited_cluster_oidc_issuer_url[len(splited_cluster_oidc_issuer_url) - 1]) // Just the OIDC ID numeric code
}
