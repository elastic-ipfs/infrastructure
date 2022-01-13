// Test cases:
// - kubectl top (Make sure metrics server is installed)
//// error: Metrics API not available
// - Make sure we have a properly configured IRSA with OIDC provider

package test

import (
	"context"
	"fmt"
	"sort"
	"testing"

	"github.com/aws/aws-sdk-go-v2/config"
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
	ctx := context.TODO()
	cfg, err := config.LoadDefaultConfig(ctx)
	cfg.Region = awsRegion
	if err != nil {
		panic("configuration error, " + err.Error())
	}
	// client := iam.
	// roles, err := client.cl

	terraformOptions := &terraform.Options{
		TerraformDir: "../example",
		Vars: map[string]interface{}{
			"region":  awsRegion,
			"profile": "nearform", // TODO: Change to oficial sandbox account
			"vpc": map[string]string{
				"name": "terratest-kube-ipfs-aws-peer-subsystem-vpc",
			},
			"config_bucket_name": "terratest-configBucket",
			"cluster_version":    "1.21",
			"cluster_name":       "terratest-ipfs-peer-subsystem",
		},
	}

	sensitiveTerraformOptions := *terraformOptions
	sensitiveTerraformOptions.Logger = logger.Discard // https://github.com/gruntwork-io/terratest/issues/358

	// defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)

	if err != nil {
		panic("DescribeVpcEndpoints error, " + err.Error())
	}


	config := &rest.Config{
		Host:        terraform.Output(t, &sensitiveTerraformOptions, "eks_host"),
		BearerToken: terraform.Output(t, &sensitiveTerraformOptions, "eks_token"),
		TLSClientConfig: rest.TLSClientConfig{
			CAData: []byte(terraform.Output(t, &sensitiveTerraformOptions, "eks_cluster_ca_certificate")),
		},
	}

	metrics, err := metrics.NewForConfig(config)
	if err != nil {
		panic(err)
	}

	kubeclient, err := kubernetes.NewForConfig(config)
	if err != nil {
		panic(err)
	}

	_, err = metrics.MetricsV1beta1().PodMetricses(metav1.NamespaceAll).List(context.TODO(), metav1.ListOptions{})
	if err != nil { // This error will happen when metrics server is not properly installed
		// "Error: the server could not find the requested resource (get pods.metrics.k8s.io)" when there isn't Metrics Server available
		fmt.Println("Error:", err)
		return
	}

	serviceAccounts, err := kubeclient.CoreV1().ServiceAccounts(metav1.NamespaceDefault).List(context.TODO(), metav1.ListOptions{})
	if err != nil {
		panic(err)
	}

	sort.SliceStable(serviceAccounts.Items, func(i, j int) bool {
		return serviceAccounts.Items[i].CreationTimestamp.Before(&serviceAccounts.Items[j].CreationTimestamp)
	})

	// TODO: Validate if roles exist in AWS with the correct policies
	// TODO: Aqui acho que também da para validar algo relacionado ao OIDC do cluster

	iam_roles := terraform.OutputMap(t, &sensitiveTerraformOptions, "iam_roles")

	assert.Equal(t, 3, len(serviceAccounts.Items)) // There is also a "default" sa
	assert.Equal(t, "bitswap-irsa", serviceAccounts.Items[1].Name)
	assert.Equal(t, "default", serviceAccounts.Items[1].Namespace)
	assert.Equal(t, serviceAccounts.Items[1].Annotations["eks.amazonaws.com/role-arn"], iam_roles["bitwsap_peer_subsystem_role"])
	assert.Equal(t, "provider-irsa", serviceAccounts.Items[2].Name)
	assert.Equal(t, "default", serviceAccounts.Items[2].Namespace)
	assert.Equal(t, serviceAccounts.Items[2].Annotations["eks.amazonaws.com/role-arn"], iam_roles["provider_peer_subsystem_role"])
}
