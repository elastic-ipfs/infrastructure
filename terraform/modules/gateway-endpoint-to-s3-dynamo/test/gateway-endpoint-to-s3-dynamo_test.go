package test

import (
	"fmt"
	"testing"

	"github.com/gruntwork-io/terratest/modules/aws"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)


func TestTerraformAwsDynamoDBExample(t *testing.T) {
	awsRegion := aws.GetRandomStableRegion(t, nil, nil)
	vpcName := "terratest-ipfs-aws-peer-subsystem-vpc"
	terraformOptions := &terraform.Options{
		TerraformDir: "../example",
		Vars: map[string]interface{} {
			"region": awsRegion,
			"profile": "nearform", // TODO: Change to oficial sandbox account
			"vpc": map[string]string {
				"name": vpcName,
			},
		},
	}
	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)
		
	vpcEndpointS3 := terraform.OutputMap(t, terraformOptions, "aws_vpc_endpoint_s3")
	vpcEndpointDynamodb := terraform.OutputMap(t, terraformOptions, "aws_vpc_endpoint_dynamodb")
	vpcEndpointRouteAssociationS3 := terraform.OutputMap(t, terraformOptions, "aws_vpc_endpoint_route_table_association_s3")
	vpcEndpointRouteAssociationDynamodb := terraform.OutputMap(t, terraformOptions, "aws_vpc_endpoint_route_table_association_dynamodb")
	
	// TODO: Validate from AWS SDK

	assert.Equal(t,fmt.Sprintf("com.amazonaws.%s.s3", awsRegion), vpcEndpointS3["service_name"])
	assert.Equal(t,fmt.Sprintf("com.amazonaws.%s.dynamodb", awsRegion), vpcEndpointDynamodb["service_name"])
	assert.Equal(t,"available", vpcEndpointS3["state"])
	assert.Equal(t,"available", vpcEndpointDynamodb["state"])
	assert.Equal(t,vpcEndpointS3["id"], vpcEndpointRouteAssociationS3["vpc_endpoint_id"])
	assert.Equal(t,vpcEndpointDynamodb["id"], vpcEndpointRouteAssociationDynamodb["vpc_endpoint_id"])

}
