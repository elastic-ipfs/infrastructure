package test

import (
	"log"
	"net/http"
	"testing"

	"github.com/gruntwork-io/terratest/modules/aws"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestTerraformAwsApiGatewayLambdaExample(t *testing.T) {
	functionName := "terratest_uploader_2"
	awsRegion := "us-west-2"
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
	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)
	invokeUrl := terraform.Output(t, terraformOptions, "upload_cars_api_invoke_url")
	lambdaResponse := aws.InvokeFunction(t, awsRegion, functionName, nil)

	apiGatewayResponse, err := http.Post(invokeUrl, "text/plain", nil)
	if err != nil {
		log.Fatalln(err)
	}

	assert.Contains(t, string(lambdaResponse), `"great success"`)
	assert.Equal(t, 200, apiGatewayResponse.StatusCode)
}
