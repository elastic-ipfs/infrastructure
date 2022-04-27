package test

import (
	"context"
	"fmt"
	"testing"

	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/ec2"
	"github.com/aws/aws-sdk-go-v2/service/ec2/types"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestTerraformAwsEndpointToS3Example(t *testing.T) {
	awsRegion := "us-west-2"
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
				"name": "terratest-ipfs-elastic-providerpeer-subsystem-vpc",
			},
		},
	}
	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)

	vpcId := terraform.Output(t, terraformOptions, "vpc_id")
	privateRouteTableIds := terraform.OutputList(t, terraformOptions, "private_route_table_ids")
	vpcEndpointS3 := terraform.OutputMap(t, terraformOptions, "aws_vpc_endpoint_s3")
	vpcEndpointRouteAssociationS3 := terraform.OutputMap(t, terraformOptions, "aws_vpc_endpoint_route_table_association_s3")

	input := &ec2.DescribeVpcEndpointsInput{
		VpcEndpointIds: []string{
			vpcEndpointS3["id"],
		},
	}
	vpcEndpointsFromAWSSDK, err := client.DescribeVpcEndpoints(ctx, input)
	if err != nil {
		panic("DescribeVpcEndpoints error, " + err.Error())
	}

	assert.Equal(t, fmt.Sprintf("com.amazonaws.%s.s3", awsRegion), vpcEndpointS3["service_name"])
	assert.Equal(t, "available", vpcEndpointS3["state"])
	assert.Equal(t, vpcId, vpcEndpointS3["vpc_id"])
	assert.Equal(t, vpcEndpointS3["id"], vpcEndpointRouteAssociationS3["vpc_endpoint_id"])
	assert.Equal(t, privateRouteTableIds[0], vpcEndpointRouteAssociationS3["route_table_id"])
	assert.Equal(t, 2, len(vpcEndpointsFromAWSSDK.VpcEndpoints))
	assert.Equal(t, types.State("available"), vpcEndpointsFromAWSSDK.VpcEndpoints[0].State)
}
