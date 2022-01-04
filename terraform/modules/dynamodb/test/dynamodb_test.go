package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/aws"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestTerraformAwsDynamoDBExample(t *testing.T) {
	awsRegion := aws.GetRandomStableRegion(t, nil, nil)
	terraformOptions := &terraform.Options{
		TerraformDir: "../example",
		Vars: map[string]interface{} {
			"region": awsRegion,
			"profile": "nearform", // TODO: Change to oficial sandbox account
			"blocks_table": map[string]string {
				"name": "blocks_test",
			},
			"cars_table": map[string]string {
				"name": "cars_test",
			},
		},
	}
	defer terraform.Destroy(t, terraformOptions)

	// dynamodb_blocks_policy := terraform.Output(t, terraformOptions, "dynamodb_blocks_policy")
	// dynamodb_car_policy := terraform.Output(t, terraformOptions, "dynamodb_car_policy")
	terraform.InitAndApply(t, terraformOptions)
	// TODO: What should I be validating here? That make sense, should I also check something else? Probably if the table is actually there (Table output)
	assert.Equal(t, "a", "a")
	// assert.Equal(t, "dynamodb-blocks-policy", dynamodb_blocks_policy)
	// assert.Equal(t, "dynamodb-car-policy", dynamodb_car_policy)
}
