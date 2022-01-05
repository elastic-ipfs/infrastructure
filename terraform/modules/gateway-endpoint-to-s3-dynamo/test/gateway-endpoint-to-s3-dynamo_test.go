package test

import (
	"context"
	"fmt"
	"testing"

	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/ec2"
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
	// defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)

	vpcEndpointS3 := terraform.OutputMap(t, terraformOptions, "aws_vpc_endpoint_s3")
	vpcEndpointDynamodb := terraform.OutputMap(t, terraformOptions, "aws_vpc_endpoint_dynamodb")
	vpcEndpointRouteAssociationS3 := terraform.OutputMap(t, terraformOptions, "aws_vpc_endpoint_route_table_association_s3")
	vpcEndpointRouteAssociationDynamodb := terraform.OutputMap(t, terraformOptions, "aws_vpc_endpoint_route_table_association_dynamodb")

	// TODO: Validate from AWS SDK
	input := &ec2.DescribeVpcEndpointsInput{
		VpcEndpointIds: []string{
			vpcEndpointS3["id"],
			vpcEndpointDynamodb["id"],
		},
	}
	// _, err = client.DescribeVpcEndpoints(ctx, input)
	vpcEndpointsFromAWS, err := client.DescribeVpcEndpoints(ctx, input)
	if err != nil {
		panic("DescribeVpcEndpoints error, " + err.Error())
	}
	// TODO: Check if length = 2
	// TODO: Check if both are at healthy status
	// TODO: Check if all associated with the correct VPCId

	fmt.Println("*************************************** VPC endpoints from AWS")
	fmt.Println(*vpcEndpointsFromAWS.VpcEndpoints[0].VpcEndpointId)
	fmt.Println(*vpcEndpointsFromAWS.VpcEndpoints[1].VpcEndpointId)
	fmt.Println("*************************************** VPC ID from AWS")
	fmt.Println(*vpcEndpointsFromAWS.VpcEndpoints[0].VpcId)
	fmt.Println(*vpcEndpointsFromAWS.VpcEndpoints[1].VpcId)
	// fmt.Printf(string(vpcEndpointsFromAWS.VpcEndpoints[0].State.Values()[0]))

	// TODO: IDEALLY: traceroute to the destination and see if it goes from within the network (This might be more interesting at live module integration test)
	//// Create something in this network: Create POD, install traceroute, get results and make sure it didn't left network
	//// https://github.com/aws/aws-sdk-go/blob/e2d6cb448883e4f4fcc5246650f89bde349041ec/example/service/s3/usingPrivateLink/README.md

	// TODO: Check if all associated with the correct VPCId
	assert.Equal(t, fmt.Sprintf("com.amazonaws.%s.s3", awsRegion), vpcEndpointS3["service_name"])
	assert.Equal(t, fmt.Sprintf("com.amazonaws.%s.dynamodb", awsRegion), vpcEndpointDynamodb["service_name"])
	assert.Equal(t, "available", vpcEndpointS3["state"])
	assert.Equal(t, "available", vpcEndpointDynamodb["state"])
	assert.Equal(t, vpcEndpointS3["id"], vpcEndpointRouteAssociationS3["vpc_endpoint_id"])
	assert.Equal(t, vpcEndpointDynamodb["id"], vpcEndpointRouteAssociationDynamodb["vpc_endpoint_id"])

}
