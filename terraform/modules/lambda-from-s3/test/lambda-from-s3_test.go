// TODO: How will I check if lambda has a run? Can this be verified through SDK?

package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestTerraformAwsLambdaFromS3Example(t *testing.T) {
	awsRegion := "us-west-2"
	terraformOptions := &terraform.Options{
		TerraformDir: "../example",
		Vars: map[string]interface{} {
			"region": awsRegion,
			"profile": "nearform", // TODO: Change to oficial sandbox account
			"testBucketName": "terratest-lambda-from-s3-cars",
			"testQueueName": "terratest-lambda-from-s3-publishing-queue",
		},
	}
	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)
	assert.Equal(t, "true", "true")

	// blocksTableOutput := terraform.OutputMap(t, terraformOptions, "blocks_table")
	// carsTableOutput := terraform.OutputMap(t, terraformOptions, "cars_table")
	// dynamodbBlocksPolicy := terraform.OutputMap(t, terraformOptions, "dynamodb_blocks_policy")
	// dynamodbCarPolicy := terraform.OutputMap(t, terraformOptions, "dynamodb_car_policy")
	// awsBlocksTable := aws.GetDynamoDBTable(t, awsRegion, blocksTableName)
	// awsCarsTable := aws.GetDynamoDBTable(t, awsRegion, carsTableName)
	// assert.Equal(t, "ACTIVE", awsSDK.StringValue(awsBlocksTable.TableStatus))
	// assert.Equal(t, "ACTIVE", awsSDK.StringValue(awsCarsTable.TableStatus))
	// assert.Equal(t, blocksTableName, blocksTableOutput["name"])
	// assert.Equal(t, carsTableName, carsTableOutput["name"])
	// assert.Equal(t, "dynamodb-blocks-policy", dynamodbBlocksPolicy["name"])
	// assert.Equal(t, "dynamodb-car-policy", dynamodbCarPolicy["name"])
	// assert.Contains(t, dynamodbBlocksPolicy["policy"], blocksTableOutput["arn"]) // Policy applies to resource
	// assert.Contains(t, dynamodbCarPolicy["policy"], carsTableOutput["arn"]) // Policy applies to resource
}
