# AWS-IPFS-Infrastructure

## Description

`AWS-IPFS-Infrastructure` is the automation responsible for provisioning the required infrastructure for the `AWS-IPFS` project.

## Terraform

### Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 3.38 |

- Configured AWS Credentials
- Existing S3 bucket (For Remote State Files) and DynamoDB table (For State Locking). DynamoDB must have a partition key called `LockID` with type `string`.

### Modules

This project is divided into modules, where each subsystem has its own. For example:

- `indexing-subsystem`
- `peer-subsystem`
- `publishing-subsystem`

There are also modules with smaller scope for grouping resources that serve a specific purpose. For example: `api-gateway-to-s3`.
