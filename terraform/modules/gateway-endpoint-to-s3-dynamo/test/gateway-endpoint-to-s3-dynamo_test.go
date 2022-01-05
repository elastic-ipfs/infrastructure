package test

import (
	"context"
	"fmt"
	"testing"

	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/ec2"
	"github.com/aws/aws-sdk-go-v2/service/ec2/types"
	"github.com/gruntwork-io/terratest/modules/aws"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestTerraformAwsDynamoDBExample(t *testing.T) {
	awsRegion := aws.GetRandomStableRegion(t, nil, nil)
	ctx := context.TODO()
	cfg, err := config.LoadDefaultConfig(ctx)
	cfg.Region = awsRegion
	if err != nil {
		panic("configuration error, " + err.Error())
	}
	client := ec2.NewFromConfig(cfg)
	terraformOptions := &terraform.Options{
		TerraformDir: "../example",
		Vars: map[string]interface{}{
			"region":  awsRegion,
			"profile": "nearform", // TODO: Change to oficial sandbox account
			"vpc": map[string]string{
				"name": "terratest-ipfs-aws-peer-subsystem-vpc",
			},
		},
	}
	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)

	vpcId := terraform.Output(t, terraformOptions, "vpc_id")
	vpcEndpointS3 := terraform.OutputMap(t, terraformOptions, "aws_vpc_endpoint_s3")
	vpcEndpointDynamodb := terraform.OutputMap(t, terraformOptions, "aws_vpc_endpoint_dynamodb")
	vpcEndpointRouteAssociationS3 := terraform.OutputMap(t, terraformOptions, "aws_vpc_endpoint_route_table_association_s3")
	vpcEndpointRouteAssociationDynamodb := terraform.OutputMap(t, terraformOptions, "aws_vpc_endpoint_route_table_association_dynamodb")


	input := &ec2.DescribeVpcEndpointsInput{
		VpcEndpointIds: []string{
			vpcEndpointS3["id"],
			vpcEndpointDynamodb["id"],
		},
	}
	vpcEndpointsFromAWSSDK, err := client.DescribeVpcEndpoints(ctx, input)
	if err != nil {
		panic("DescribeVpcEndpoints error, " + err.Error())
	}

	// TODO: Check if association with route table
	assert.Equal(t, fmt.Sprintf("com.amazonaws.%s.s3", awsRegion), vpcEndpointS3["service_name"])
	assert.Equal(t, fmt.Sprintf("com.amazonaws.%s.dynamodb", awsRegion), vpcEndpointDynamodb["service_name"])
	assert.Equal(t, "available", vpcEndpointS3["state"])
	assert.Equal(t, "available", vpcEndpointDynamodb["state"])
	assert.Equal(t, vpcId, vpcEndpointS3["vpc_id"])
	assert.Equal(t, vpcId, vpcEndpointDynamodb["vpc_id"])
	assert.Equal(t, vpcEndpointS3["id"], vpcEndpointRouteAssociationS3["vpc_endpoint_id"])
	assert.Equal(t, vpcEndpointDynamodb["id"], vpcEndpointRouteAssociationDynamodb["vpc_endpoint_id"])
	assert.Equal(t, 2, len(vpcEndpointsFromAWSSDK.VpcEndpoints))
	assert.Equal(t, types.State("available"), vpcEndpointsFromAWSSDK.VpcEndpoints[0].State)
	assert.Equal(t, types.State("available"), vpcEndpointsFromAWSSDK.VpcEndpoints[1].State)
}
