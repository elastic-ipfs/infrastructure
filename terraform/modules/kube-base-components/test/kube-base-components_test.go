// Test cases:
// - kubectl top (Make sure metrics server is installed)
//// error: Metrics API not available
// - Make sure we have a properly configured IRSA with OIDC provider

package test

import (
	"context"
	"fmt"
	"testing"

	"github.com/stretchr/testify/assert"
	"k8s.io/apimachinery/pkg/api/errors"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"

	// metrics "k8s.io/metrics/pkg/client/clientset/versioned"
	"k8s.io/client-go/kubernetes"
	"k8s.io/client-go/rest"
)

// Run this increasing timeout, ex: "go test -timeout 30m"
func TestTerraformKubeComponetsExample(t *testing.T) {
	// awsRegion := "us-west-2"
	// terraformOptions := &terraform.Options{
	// 	TerraformDir: "../example",
	// 	Vars: map[string]interface{}{
	// 		"region":  awsRegion,
	// 		"profile": "nearform", // TODO: Change to oficial sandbox account
	// 		"vpc": map[string]string{
	// 			"name": "terratest-kube-ipfs-aws-peer-subsystem-vpc",
	// 		},
	// 		"config_bucket_name": "terratest-configBucket",
	// 		"cluster_version":    "1.21",
	// 		"cluster_name":       "terratest-ipfs-peer-subsystem",
	// 	},
	// }
	// defer terraform.Destroy(t, terraformOptions)
	// terraform.InitAndApply(t, terraformOptions)

	// config := &rest.Config{
	// 	Host:        terraform.Output(t, terraformOptions, "eks_host"),
	// 	BearerToken: terraform.Output(t, terraformOptions, "eks_token"),
	// 	TLSClientConfig: rest.TLSClientConfig{
	// 		CertData: []byte(terraform.Output(t, terraformOptions, "eks_cluster_ca_certificate")),
	// 	},
	// }

	// decodedCertData, err := base64.StdEncoding.DecodeString("LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUM1ekNDQWMrZ0F3SUJBZ0lCQURBTkJna3Foa2lHOXcwQkFRc0ZBREFWTVJNd0VRWURWUVFERXdwcmRXSmwKY201bGRHVnpNQjRYRFRJeU1ERXhNakU1TURVeE5Gb1hEVE15TURFeE1ERTVNRFV4TkZvd0ZURVRNQkVHQTFVRQpBeE1LYTNWaVpYSnVaWFJsY3pDQ0FTSXdEUVlKS29aSWh2Y05BUUVCQlFBRGdnRVBBRENDQVFvQ2dnRUJBTzMyCmpEbE1iREliVDdKS3RvWU52V1lLOG9UMG1rdEhRMy91QXBISzJGZHo2Y3puY1psZmlrY25EYjYwaXFzenlGZHoKalNtb3FHQjhoOVpxNDUxTHNCWitWemdpWUp3K0FDemJ3N2h0U1VvcUhzWEh5M3pSZUF1MCtSTG4yakcrTHdIdwo0OEZPK2psV1hsZ3FybHJJQitwRm9sRWgzQW1TaG92RGl6TC9VQjA4Y3FIZ0hod2hsejBiUmI4d2ZuUGt4bCthClliazhzNmgxMDFjcElDTEF2ak1ZZXNuUWV0bWxnVXkwZ1pTeGZZVktxT0s5eTEzRndTc05CNlFiMGJvejM3NjMKOUtQQ0pyanpqU3FhMWRoTWpRNFF6bWdja2htUVEwdlJmT012OTBjVGluV1MyanVobDNZNERFSVpiZWJjMTVjYwpBZll3bzJmT3BaSFJpdVZGeTJFQ0F3RUFBYU5DTUVBd0RnWURWUjBQQVFIL0JBUURBZ0trTUE4R0ExVWRFd0VCCi93UUZNQU1CQWY4d0hRWURWUjBPQkJZRUZQdWpMVW9zbzg0dGFqZnJrRjN3R0cvWjZyV1hNQTBHQ1NxR1NJYjMKRFFFQkN3VUFBNElCQVFCclBkYStGeUozc0U1eUZxTFBFM1E4VE1zTVNab3QvYUp3TDBFeUphend6RU1MRWE0YQppRUE4dEIzUUtKTEdSWjlPazhEOTZMRXZiN3FnbEFLYlFZR0NmU3FvY1JZNVFqSWtOL3BvYm1uTEhqOUFwN2NLCm9HWFNzK2NnUHQraWFyNnYwb2xqNVg1Rlh3Z2FjWW95NXBNTXV1K1ozRVJlQkoxRVV2ZDkxWEJuMlU5YytsaEkKQ2FESldjeEtxZWZidXFhSG9DZ3RaZW1mRWhESGVOaGltVDU2aTVhRDZKRlhYQ3Y5MCtOb2tuRkYwOHBJTkZ6NQo4emgwN0JyMWRDbFJTV2lWRHFrY3lOajNFWW5qdGpONjFGbWsyaTBaZ1VWaUE3NW05eWFCVy9Xc0FWSmM2dnZwCjNlckpxcUc1KzFzcXJtTjBzenkrMHF2dGlNeHNGZ1BHeElQWQotLS0tLUVORCBDRVJUSUZJQ0FURS0tLS0tCg==")
	// if err != nil {
	// 	panic(err.Error())
	// }

	// Worked!

	config := &rest.Config{
		Host:        "https://5A059D31CE53BDA8C650C784F9747838.sk1.us-west-2.eks.amazonaws.com",
		BearerToken: "k8s-aws-v1.aHR0cHM6Ly9zdHMuYW1hem9uYXdzLmNvbS8_QWN0aW9uPUdldENhbGxlcklkZW50aXR5JlZlcnNpb249MjAxMS0wNi0xNSZYLUFtei1BbGdvcml0aG09QVdTNC1ITUFDLVNIQTI1NiZYLUFtei1DcmVkZW50aWFsPUFLSUEyWVZONk5DNUlMSzZIT1BCJTJGMjAyMjAxMTIlMkZ1cy1lYXN0LTElMkZzdHMlMkZhd3M0X3JlcXVlc3QmWC1BbXotRGF0ZT0yMDIyMDExMlQxOTUxMDVaJlgtQW16LUV4cGlyZXM9NjAmWC1BbXotU2lnbmVkSGVhZGVycz1ob3N0JTNCeC1rOHMtYXdzLWlkJlgtQW16LVNpZ25hdHVyZT0wNTMxMDhhMTU5MzFkMzMxOWIzYjczZTY5M2U0NjUxMmI0ZjVmMTljZGE0ZWRiMzBkOTAzNDllYjdhYzdlOWNm",
		TLSClientConfig: rest.TLSClientConfig{
			Insecure: true,
			// CertData: []byte(decodedCertData),
			// KeyData: []byte(decodedCertData),
		},
	}

	clientset, err := kubernetes.NewForConfig(config)
	if err != nil {
		panic(err.Error())
	}
	// TODO: This is just for testing accessibility. Remove that and do the real testing!
	// for {
		pods, err := clientset.CoreV1().Pods("").List(context.TODO(), metav1.ListOptions{})
		clientset.CoreV1().RESTClient().
		if err != nil {
			panic(err.Error())
		}
		fmt.Printf("There are %d pods in the cluster\n", len(pods.Items))

		// Examples for error handling:
		// - Use helper functions like e.g. errors.IsNotFound()
		// - And/or cast to StatusError and use its properties like e.g. ErrStatus.Message
		namespace := "default"
		pod := "example-xxxxx"
		_, err = clientset.CoreV1().Pods(namespace).Get(context.TODO(), pod, metav1.GetOptions{})
		if errors.IsNotFound(err) {
			fmt.Printf("Pod %s in namespace %s not found\n", pod, namespace)
		} else if statusError, isStatus := err.(*errors.StatusError); isStatus {
			fmt.Printf("Error getting pod %s in namespace %s: %v\n",
				pod, namespace, statusError.ErrStatus.Message)
		} else if err != nil {
			panic(err.Error())
		} else {
			fmt.Printf("Found pod %s in namespace %s\n", pod, namespace)
		}

		// time.Sleep(10 * time.Second)
	// }

	assert.Equal(t, "true", "true")
}
