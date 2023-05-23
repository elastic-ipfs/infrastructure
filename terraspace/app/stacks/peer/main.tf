terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.38"
    }

    http = {
      source  = "hashicorp/http"
      version = "~> 2.1"
    }
  }
  required_version = ">= 1.0.0"
}

data "aws_eks_cluster" "eks" {
  name = module.eks.cluster_id
}

data "aws_availability_zones" "available" {
}

data "aws_default_tags" "current" {}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 3.0"

  name                 = var.vpc.name
  cidr                 = var.vpc.cidr
  azs                  = data.aws_availability_zones.available.names
  private_subnets      = var.vpc.private_subnets # Worker Nodes
  public_subnets       = var.vpc.public_subnets  # LoadBalancer and NAT
  enable_nat_gateway   = var.vpc.enable_nat_gateway
  single_nat_gateway   = var.vpc.single_nat_gateway
  enable_dns_hostnames = var.vpc.enable_dns_hostnames

  public_subnet_tags = {
    "kubernetes.io/cluster/${var.eks.name}" = "shared"
    "kubernetes.io/role/elb"                = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${var.eks.name}" = "shared"
    "kubernetes.io/role/internal-elb"       = "1"
  }
}

module "gateway_endpoint_to_dynamodb" {
  source         = "../../modules/gateway-endpoint-to-dynamodb"
  vpc_id         = module.vpc.vpc_id
  region         = local.region
  route_table_id = module.vpc.private_route_table_ids[0]
}

module "gateway_endpoint_to_s3" {
  source         = "../../modules/gateway-endpoint-to-s3"
  vpc_id         = module.vpc.vpc_id
  region         = local.region
  route_table_id = module.vpc.private_route_table_ids[0]
}

# TODO: Investigate alternative approach to make GitHub Actions Self Runner access EKS through the cluster private endpoint

module "eks" {
  source                             = "terraform-aws-modules/eks/aws"
  version                            = "~> 18.29.1"
  cluster_name                       = var.eks.name
  cluster_version                    = var.eks.version
  cluster_endpoint_private_access    = true
  cluster_endpoint_public_access     = true
  vpc_id                             = module.vpc.vpc_id
  subnet_ids                         = [module.vpc.private_subnets[0], module.vpc.private_subnets[1]]
  enable_irsa                        = true # To be able to access AWS services from PODs  
  cluster_security_group_description = "EKS cluster security group - Control Plane"

  cluster_endpoint_public_access_cidrs = [
    "62.232.226.28/32", # alan
    "86.183.170.43/32", # alan
    "86.56.31.53/32", # vasco
  ]

  eks_managed_node_groups = { # Needed for CoreDNS (https://docs.aws.amazon.com/eks/latest/userguide/fargate-getting-started.html)
    (var.eks.eks_managed_node_groups.name) = {
      name         = var.eks.name
      desired_size = var.eks.eks_managed_node_groups.desired_size
      min_size     = var.eks.eks_managed_node_groups.min_size
      max_size     = var.eks.eks_managed_node_groups.max_size
      instance_types = var.eks.eks_managed_node_groups.instance_types
      ami_type     = var.eks.eks_managed_node_groups.ami_type
      k8s_labels = {
        workerType = "managed_ec2_node_groups"
      }
      update_config = {
        max_unavailable_percentage = 50
      }
      launch_template_tags = merge(
        data.aws_default_tags.current.tags, {
        "k8s.io/cluster-autoscaler/${var.eks.name}" : "owned"
        "k8s.io/cluster-autoscaler/enabled" : "TRUE"
      })
      iam_role_tags = {
        "eks/${var.account_id}/${var.eks.name}/type" : "node"
      }
    }
  }

  node_security_group_additional_rules = merge(
    local.node_security_group_additional_rules["base_rules"],
    local.node_security_group_additional_rules[var.enable_troubleshooting_sg_rules ? "troubleshooting_rules" : "base_rules"]
  )

  fargate_profiles = {
    default = {
      name       = "default"
      subnet_ids = module.vpc.private_subnets
      selectors = [
        {
          namespace = "default"
          labels = {
            workerType = "fargate"
          }
        }
      ]

      tags = { # This is also applied to IAM role.
        "eks/${var.account_id}/${var.eks.name}/type" : "fargateNode"
      }
      timeouts = {
        create = "5m"
        delete = "5m"
      }
    }
  }
}

resource "aws_security_group_rule" "fargate_ingress" {
  description              = "Node to cluster - Fargate kubelet (Required for Metrics Server)"
  type                     = "ingress"
  from_port                = 10250
  to_port                  = 10250
  protocol                 = "tcp"
  source_security_group_id = module.eks.node_security_group_id
  security_group_id        = module.eks.cluster_primary_security_group_id
}


resource "aws_security_group_rule" "fargate_egress" {
  description              = "Node to cluster - Fargate kubelet (Required for Metrics Server)"
  protocol                 = "tcp"
  from_port                = 10250
  to_port                  = 10250
  type                     = "egress"
  source_security_group_id = module.eks.cluster_primary_security_group_id
  security_group_id        = module.eks.node_security_group_id
}

resource "aws_security_group_rule" "dns_ingress_tcp" {
  description              = "Fargate to DNS (TCP)"
  type                     = "ingress"
  from_port                = 53
  to_port                  = 53
  protocol                 = "tcp"
  source_security_group_id = module.eks.cluster_primary_security_group_id
  security_group_id        = module.eks.node_security_group_id
}

resource "aws_security_group_rule" "dns_ingress_udp" {
  description              = "Fargate to DNS (UDP)"
  type                     = "ingress"
  from_port                = 53
  to_port                  = 53
  protocol                 = "udp"
  source_security_group_id = module.eks.cluster_primary_security_group_id
  security_group_id        = module.eks.node_security_group_id
}

resource "aws_dynamodb_table" "config_table" {
  name         = var.config_table.name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = var.config_table.hash_key
  attribute {
    name = var.config_table.hash_key
    type = "S"
  }

  point_in_time_recovery {
    enabled = true
  }
}
