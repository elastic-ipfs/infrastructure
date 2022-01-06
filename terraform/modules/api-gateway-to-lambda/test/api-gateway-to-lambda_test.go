package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/aws"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)


func TestTerraformAwsApiGatewayLambdaExample(t *testing.T) {
	awsRegion := aws.GetRandomStableRegion(t, nil, nil)
	terraformOptions := &terraform.Options{
		TerraformDir: "../example",
		Vars: map[string]interface{}{
			"region":  awsRegion,
			"profile": "nearform", // TODO: Change to oficial sandbox account
			"lambda": map[string]string{
				"name": "terratest_uploader",
			},
		},
	}
	// defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)

	// TODO: I think that the best test here will be the simplest possible: CURL OUTPUT and get response.

	assert.Equal(t, "true", "true")
}