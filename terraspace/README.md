# Terraspace Project

This is a Terraspace project. It contains code to provision Cloud infrastructure built with [Terraform](https://www.terraform.io/) and the [Terraspace Framework](https://terraspace.cloud/).

## Deploy

To deploy all the infrastructure stacks:

    AWS_PROFILE=<profile> AWS_REGION=<region> TS_ENV=<environment> bundle exec terraspace all up
    terraspace all up

To deploy individual stacks:

    AWS_PROFILE=<profile> AWS_REGION=<region> TS_ENV=<environment> bundle exec terraspace up shared-subsystem
    terraspace up demo # where demo is app/stacks/demo

## Terrafile

To use more modules, add them to the [Terrafile](https://terraspace.cloud/docs/terrafile/).
