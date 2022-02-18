# ipfs-elastic-provider-infrastructure

## Description

`ipfs-elastic-provider-infrastructure` is the automation responsible for provisioning the required infrastructure for the `IPFS-Elastic-Provider` project.

## Terraform

### Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 3.38 |

- AWS CLI 
- Configured AWS Credentials
- Existing S3 bucket (For Remote State Files) and DynamoDB table (For State Locking). DynamoDB must have a partition key called `LockID` with type `string`.

### Modules

This project is divided into modules, where each subsystem has its own. For example:

- [`shared-modules`](terraform/shared-subsystem/shared-subsystem.md) (Base resources used by multiple subsystems)
- [`indexing-subsystem`](terraform/indexing-subsystem/indexing-subsystem.md)
- [`peer-subsystem`](terraform/peer-subsystem/peer-subsystem.md)
- `publishing-subsystem`
- [`dns`](terraform/dns/readme.md)

There are also modules with smaller scope for grouping resources that serve a specific purpose. For example:
- [`api-gateway-to-lambda`](terraform/modules/api-gateway-to-lambda/api-gateway-to-lambda.md)
- [`dynamodb`](terraform/modules/dynamodb/dynamodb.md)
- [`eks-auth-sync`](terraform/modules/eks-auth-sync/README.md)
- [`gateway-endpoint-to-s3-dynamo`](terraform/modules/gateway-endpoint-to-s3-dynamo/README.md)
- [`kube-base-components`](terraform/modules/kube-base-components/README.md)
- [`lambda-from-s3`](terraform/modules/lambda-from-s3/lambda-from-s3.md)

## Terratest

From root folder:
``` sh
go mod init github.com/web3-storage/ipfs-elastic-provider-infrastructure
go mod tidy
cd <test-folder>
go test
```
