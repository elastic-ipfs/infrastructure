package test

import (
	"context"
	"testing"
	"time"

	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/gruntwork-io/terratest/modules/logger"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/client-go/kubernetes"
	"k8s.io/client-go/rest"
)

// Run this increasing timeout, ex: "go test -timeout 30m"
func TestTerraformEksAuthSyncExample(t *testing.T) {
	awsRegion := "us-west-2"
	adminUserName := "terratestkubeadminuser"
	ctx := context.TODO()
	cfg, err := config.LoadDefaultConfig(ctx)
	cfg.Region = awsRegion

	if err != nil {
		panic("configuration error, " + err.Error())
	}

	terraformOptions := &terraform.Options{
		TerraformDir: "../example",
		Vars: map[string]interface{}{
			"region":    awsRegion,
			"profile":   "nearform",     // TODO: Change to oficial sandbox account
			"accountId": "740172916922", // TODO: Change to oficial sandbox account
			"vpc": map[string]string{
				"name": "terratest-ipfs-authsync",
			},
			"cluster_version":           "1.21",
			"cluster_name":              "terratest-ipfs-authsync",
			"cronjob_schedule":          "*/1 * * * *",
			"eks_auth_sync_policy_name": "terratest-eks-auth-sync",
			"eks_auth_sync_role_name":   "terratest-eks-auth-sync",
			"eks_admin_user_name":           adminUserName,
		},
	}

	sensitiveTerraformOptions := *terraformOptions
	sensitiveTerraformOptions.Logger = logger.Discard // https://github.com/gruntwork-io/terratest/issues/358

	// defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)

	config := &rest.Config{
		Host:        terraform.Output(t, &sensitiveTerraformOptions, "eks_host"),
		BearerToken: terraform.Output(t, &sensitiveTerraformOptions, "eks_token"),
		TLSClientConfig: rest.TLSClientConfig{
			CAData: []byte(terraform.Output(t, &sensitiveTerraformOptions, "eks_cluster_ca_certificate")),
		},
	}

	assertAwsAuthConfigMap(config, t, terraformOptions, adminUserName)
}

func assertAwsAuthConfigMap(config *rest.Config, t *testing.T, terraformOptions *terraform.Options, adminUserName string) {
	kubeclient, err := kubernetes.NewForConfig(config)
	if err != nil {
		panic(err)
	}

	time.Sleep(time.Second * 75) // Wait for Cronjob to update aws-auth configmap

	awsAuthConfigClient, err := kubeclient.CoreV1().ConfigMaps(metav1.NamespaceSystem).Get(context.TODO(), "aws-auth", metav1.GetOptions{})
	if err != nil {
		panic(err)
	}

	managedNodeGroupIam := terraform.Output(t, terraformOptions, "managed_node_group_iam_role")
	fargateIamRole := terraform.Output(t, terraformOptions, "fargate_iam_role")

	// Node Roles
	assert.Contains(t, awsAuthConfigClient.Data["mapRoles"], managedNodeGroupIam)
	assert.Contains(t, awsAuthConfigClient.Data["mapRoles"], fargateIamRole)
	assert.Contains(t, awsAuthConfigClient.Data["mapRoles"], "system:node:{{EC2PrivateDNSName}}")
	assert.Contains(t, awsAuthConfigClient.Data["mapRoles"], "system:node:{{SessionName}}")
	assert.Contains(t, awsAuthConfigClient.Data["mapRoles"], "system:bootstrappers")
	assert.Contains(t, awsAuthConfigClient.Data["mapRoles"], "system:nodes")
	assert.Contains(t, awsAuthConfigClient.Data["mapRoles"], "system:node-proxier")
	// Users
	assert.Contains(t, awsAuthConfigClient.Data["mapUsers"], adminUserName)
	assert.Contains(t, awsAuthConfigClient.Data["mapUsers"], "system:masters")
}
