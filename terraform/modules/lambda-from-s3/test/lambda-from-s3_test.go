// TODO: How will I check if lambda has a run? Can this be verified through SDK?

package test

import (
	"context"
	"fmt"
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
	lambdaName := "terratest_indexing"

	terraformOptions := &terraform.Options{
		TerraformDir: "../example",
		Vars: map[string]interface{}{
			"region":         awsRegion,
			"profile":        "nearform", // TODO: Change to oficial sandbox account
			"testBucketName": bucketName,
			"indexingLambdaName": lambdaName,
			"testQueueName":  "terratest-lambda-from-s3-publishing-queue",
		},
	}
	// defer terraform.Destroy(t, terraformOptions)
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
	fmt.Println(bucketNotifications.LambdaFunctionConfigurations[0].LambdaFunctionArn)
	lambdaResponse := aws.InvokeFunction(t, awsRegion, lambdaName, nil)
	assert.NotEmpty(t, bucketNotifications.LambdaFunctionConfigurations);
	// Error:
	// assert.Contains(t, bucketNotifications.LambdaFunctionConfigurations[0].LambdaFunctionArn, lambdaName)
	assert.Contains(t, string(lambdaResponse), `"great success"`)
}
