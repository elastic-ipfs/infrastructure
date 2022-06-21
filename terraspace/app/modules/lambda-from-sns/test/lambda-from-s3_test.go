// TODO: How will I check if lambda has a run? Can this be verified through SDK?

package test

import (
	"context"
	"strings"
	"testing"

	awsSDK "github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/s3"
	"github.com/gruntwork-io/terratest/modules/aws"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestTerraformAwsLambdaFromS3Example(t *testing.T) {

	awsRegion := "us-west-2"
	bucketName := "terratest-lambda-from-s3-cars"

	terraformOptions := &terraform.Options{
		TerraformDir: "../example",
		Vars: map[string]interface{}{
			"region":         awsRegion,
			"profile":        "nearform", // TODO: Change to oficial sandbox account
			"testBucketName": bucketName,
			"lambdaName": "terratest_indexing",
			"testQueueName":  "terratest-lambda-from-s3-publishing-queue",
		},
	}
	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)
	ctx := context.TODO()
	cfg, err := config.LoadDefaultConfig(ctx)
	cfg.Region = awsRegion
	if err != nil {
		panic("configuration error, " + err.Error())
	}
	client := s3.NewFromConfig(cfg)
	bucketNotifications, err := client.GetBucketNotificationConfiguration(ctx, &s3.GetBucketNotificationConfigurationInput{
		Bucket: awsSDK.String(bucketName),		
	})
	if err != nil {
		panic("error getting bucket notifications, " + err.Error())
	}
	lambdaNameOutput := terraform.Output(t, terraformOptions, "lambda_function_name")
	lambdaResponse := aws.InvokeFunction(t, awsRegion, lambdaNameOutput, nil)
	assert.Contains(t, string(lambdaResponse), `"great success"`)
	assert.NotEmpty(t, bucketNotifications.LambdaFunctionConfigurations);
	splitedLambdaFunctionArnFromBucketNotification := strings.SplitAfter(*bucketNotifications.LambdaFunctionConfigurations[0].LambdaFunctionArn, ":")
	assert.Equal(t, splitedLambdaFunctionArnFromBucketNotification[len(splitedLambdaFunctionArnFromBucketNotification) - 1], lambdaNameOutput)
}
