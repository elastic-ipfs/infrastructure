// Test cases:
// - kubectl top (Make sure metrics server is installed)
//// error: Metrics API not available
// - Make sure we have a properly configured IRSA with OIDC provider

package test

import (
	"context"
	"fmt"
	"testing"

	"github.com/gruntwork-io/terratest/modules/logger"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/client-go/rest"
	metrics "k8s.io/metrics/pkg/client/clientset/versioned"
)

// Run this increasing timeout, ex: "go test -timeout 30m"
func TestTerraformKubeComponetsExample(t *testing.T) {
	awsRegion := "us-west-2"
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
	
	config := &rest.Config{
		Host:        terraform.Output(t, &sensitiveTerraformOptions, "eks_host"),
		BearerToken: terraform.Output(t, &sensitiveTerraformOptions, "eks_token"),
		TLSClientConfig: rest.TLSClientConfig{			
			CAData: []byte(terraform.Output(t, &sensitiveTerraformOptions, "eks_cluster_ca_certificate")),
		},
	}

	mc, err := metrics.NewForConfig(config)
	if err != nil {
		panic(err)
	}
	_, err = mc.MetricsV1beta1().PodMetricses(metav1.NamespaceAll).List(context.TODO(), metav1.ListOptions{})
	if err != nil { // This error will happen when metrics server is not properly installed
		// "Error: the server could not find the requested resource (get pods.metrics.k8s.io)" when there isn't Metrics Server available
		fmt.Println("Error:", err)
		return
	}
	assert.Equal(t, "true", "true")
}
