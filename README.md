# ipfs-elastic-provider-infrastructure

## Description

`ipfs-elastic-provider-infrastructure` is the automation responsible for provisioning the required infrastructure for the `IPFS-Elastic-Provider` project.

## Architecture Diagrams

![simplified arch](https://s3.us-west-2.amazonaws.com/secure.notion-static.com/f8715501-9f03-433e-9324-66c7d50a2357/IPFS_Elastic_Provider.jpg?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Credential=AKIAT73L2G45EIPT3X45%2F20220314%2Fus-west-2%2Fs3%2Faws4_request&X-Amz-Date=20220314T220710Z&X-Amz-Expires=86400&X-Amz-Signature=0c60b43dbe2127e724fd0ccb309030551430f80b7b4927105f5aade043d123df&X-Amz-SignedHeaders=host&response-content-disposition=filename%20%3D%22IPFS%2520Elastic%2520Provider.jpg%22&x-id=GetObject)

### Detailed Architecture Diagram

![detailed arch](https://s3.us-west-2.amazonaws.com/secure.notion-static.com/f0fdea90-cc5c-49ba-a1a1-4bceb22c0861/IPFSSingleNode-v5.drawio.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Credential=AKIAT73L2G45EIPT3X45%2F20220314%2Fus-west-2%2Fs3%2Faws4_request&X-Amz-Date=20220314T220848Z&X-Amz-Expires=86400&X-Amz-Signature=65ceb5eae99f36e8fe8f3c8ea3f3534e48eaa2cd449983bd21b89076bb5095a7&X-Amz-SignedHeaders=host&response-content-disposition=filename%20%3D%22IPFSSingleNode-v5.drawio.png%22&x-id=GetObject)

### Indexer Subsystem Diagram

![indexer arch](https://s3.us-west-2.amazonaws.com/secure.notion-static.com/e2d3c67f-ab20-49dc-94ea-a57f31faec2d/simplified-indexing.jpg?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Credential=AKIAT73L2G45EIPT3X45%2F20220314%2Fus-west-2%2Fs3%2Faws4_request&X-Amz-Date=20220314T220956Z&X-Amz-Expires=86400&X-Amz-Signature=8e08caf5411b576b8ab3d53e0e48b894819ffe57520a473f0e15f9587bac9c77&X-Amz-SignedHeaders=host&response-content-disposition=filename%20%3D%22simplified-indexing.jpg%22&x-id=GetObject)

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
- [`publishing-subsystem`](terraform/publishing-subsystem/publishing-subsystem.md)
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
