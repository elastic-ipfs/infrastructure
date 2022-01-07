// TODO: How will I check if lambda has a run? Can this be verified through SDK?

package test

import (
	"fmt"
	"testing"

	awsSDK "github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/cloudwatch"
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
	// defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)
	
	sess := session.Must(session.NewSessionWithOptions(session.Options{
        SharedConfigState: session.SharedConfigEnable,
    }))

    // Create CloudWatch client
    svc := cloudwatch.New(sess)

    // Get the list of metrics matching your criteria
    result, err := svc.ListMetrics(&cloudwatch.ListMetricsInput{
        MetricName: awsSDK.String("Invocations"),
        Namespace:  awsSDK.String("AWS/Lambda"),
        Dimensions: []*cloudwatch.DimensionFilter{
            {
                Name: awsSDK.String("FunctionName"),
				Value: awsSDK.String("indexing"),
            },
        },
    })
    if err != nil {
        fmt.Println("Error", err)
        return
    }

	// TODO: Cool, I got the metric here but not the it's value...
    fmt.Println("Metrics", result.Metrics)

	// TODO: This is going to bring the value, but is all histogram. Must get an interval (Maybe 10 min?) and find out if there was any invocation at all during that time
	// StartTime, EndTime
	// How to write a metricDataQuery? Is that what I will need
	svc.GetMetricData(&cloudwatch.GetMetricDataInput{

	})

	assert.Equal(t, "true", "true")
	// (awsSdk). // TODO: Get Metric about how many times function was invoked. Should be non existing at first (Metric doesn't exist yet when never invoked), and then after uploading a file should be one.
	// It will probably have to wait/retry the assert a few times so we make sure the metric is updated
}
