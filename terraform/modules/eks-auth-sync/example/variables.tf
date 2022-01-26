variable "region" {
  type = string
}

variable "profile" {
  type = string
}

variable "vpc" {
  type = object({
    name = string
  })
}

variable "cluster_name" {
  type = string
}

variable "cluster_version" {
  type = string
}