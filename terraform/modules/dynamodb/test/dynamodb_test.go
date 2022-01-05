package test

import (
	"testing"

	awsSDK "github.com/aws/aws-sdk-go/aws"
	"github.com/gruntwork-io/terratest/modules/aws"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestTerraformAwsDynamoDBExample(t *testing.T) {
	blocksTableName := "blocks_test"
	carsTableName := "cars_test"
	awsRegion := aws.GetRandomStableRegion(t, nil, nil)
	terraformOptions := &terraform.Options{
		TerraformDir: "../example",
		Vars: map[string]interface{} {
			"region": awsRegion,
			"profile": "nearform", // TODO: Change to oficial sandbox account
			"blocks_table": map[string]string {
				"name": blocksTableName,
			},
			"cars_table": map[string]string {
				"name": carsTableName,
			},
		},
	}
	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)
	blocksTableOutput := terraform.OutputMap(t, terraformOptions, "blocks_table")
	carsTableOutput := terraform.OutputMap(t, terraformOptions, "cars_table")
	dynamodbBlocksPolicy := terraform.OutputMap(t, terraformOptions, "dynamodb_blocks_policy")
	dynamodbCarPolicy := terraform.OutputMap(t, terraformOptions, "dynamodb_car_policy")
	awsBlocksTable := aws.GetDynamoDBTable(t, awsRegion, blocksTableName)
	awsCarsTable := aws.GetDynamoDBTable(t, awsRegion, carsTableName)
	assert.Equal(t, "ACTIVE", awsSDK.StringValue(awsBlocksTable.TableStatus))
	assert.Equal(t, "ACTIVE", awsSDK.StringValue(awsCarsTable.TableStatus))
	assert.Equal(t, blocksTableName, blocksTableOutput["name"])
	assert.Equal(t, carsTableName, carsTableOutput["name"])
	assert.Equal(t, "dynamodb-blocks-policy", dynamodbBlocksPolicy["name"])
	assert.Equal(t, "dynamodb-car-policy", dynamodbCarPolicy["name"])
	assert.Contains(t, dynamodbBlocksPolicy["policy"], blocksTableOutput["arn"]) // Policy applies to resource
	assert.Contains(t, dynamodbCarPolicy["policy"], carsTableOutput["arn"]) // Policy applies to resource
}
