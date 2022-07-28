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

This project is divided into live stacks and shared modules, according to the [Terraspace project structure](https://terraspace.cloud/docs/intro/structure/). Stacks are organized based on the subsystem components defined [here](https://github.com/elastic-ipfs/elastic-ipfs#components). Check [stacks](terraspace/app/stacks) and [modules](terraspace/app/modules) folders.
