package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/aws"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestTerraformAwsApiGatewayLambdaExample(t *testing.T) {
	functionName := "terratest_uploader"
	awsRegion := aws.GetRandomStableRegion(t, nil, nil)
	terraformOptions := &terraform.Options{
		TerraformDir: "../example",
		Vars: map[string]interface{}{
			"region":  awsRegion,
			"profile": "nearform", // TODO: Change to oficial sandbox account
			"lambda": map[string]string{
				"name": functionName,
			},
		},
	}
	// defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)
	lambdaResponse := aws.InvokeFunction(t, awsRegion, functionName, nil)

	// TODO: I think that the best test here will be the simplest possible: CURL OUTPUT and get response.
	// TODO: This should be a PUT method
	// apiGatewayResponse, err := http.Get(invokeUrl) 
	// if err != nil {
	// 	log.Fatalln(err)
	// }

	assert.Equal(t, `"great success"`, string(lambdaResponse))
}
