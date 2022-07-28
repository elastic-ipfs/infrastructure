# Infrastructure

## Description

`infrastructure` is the automation responsible for provisioning the required infrastructure for the `Elastic IPFS` project.

## Terraspace

### Requirements

| Name | Version |
|------|---------|
| aws        | ~> 3.38 |
| ruby       | ~> 3.1.0 |
| terraform  | >= 1.0.0 |
| terraspace | ~> 1.1.0 |

- AWS CLI 
- Configured AWS Credentials

### Stacks and Shared Modules

This project is divided into live stacks. They are organized based on the subsystem components defined [here](https://github.com/elastic-ipfs/elastic-ipfs). You can find them in [stacks folder](terraspace/app/stacks).

There are also shared modules which group resources that serve a specific purpose. For example:

- [`eks-auth-sync`](terraspace/app/modules/eks-auth-sync/README.md)
- [`lambda-from-sqs`](terraspace/app/modules/lambda-from-sqs/README.md)
