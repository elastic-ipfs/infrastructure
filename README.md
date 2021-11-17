# AWS-IPFS-Infrastructure

## Description

`AWS-IPFS-Infrastructure` is the automation responsible for provisioning the required infrastructure for the `AWS-IPFS` project.

## Terraform

### Modules

This project is divided into modules, where each subsystem has its own. For example:

- `Indexing Subsystem`
- `Peer Subsystem`
- `Publishing Subsystem`

There are also modules with smaller scope for grouping resources that serve a specific purpose. For example: `api-gateway-to-s3`.
