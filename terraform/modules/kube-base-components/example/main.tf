terraform {
  required_version = ">= 1.0.0"
}

provider "aws" {
  profile = var.profile
  region  = var.region
  default_tags {
    tags = {
      Team       = "NearForm"
      Project    = "IPFS-Elastic-Provider"
      ManagedBy  = "Terraform"
      Example    = "true"
      Production = "false"
    }
  }
}

data "aws_availability_zones" "available" {
}
data "aws_eks_cluster" "eks" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "eks" {
  name = module.eks.cluster_id
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 3.0"

  name                 = var.vpc.name
  cidr                 = "10.4.0.0/16"
  azs                  = data.aws_availability_zones.available.names
  private_subnets      = ["10.4.1.0/24", "10.4.2.0/24", "10.4.3.0/24", "10.4.4.0/24"] # Worker Nodes
  public_subnets       = ["10.4.5.0/24", "10.4.6.0/24", "10.4.7.0/24"]                # LoadBalancer and NAT
  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true
  public_subnet_tags = {
    "terraform/example"                         = "true"
    "Production"                                = "false"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                    = "1"
  }

  private_subnet_tags = {
    "terraform/example"                         = "true"
    "Production"                                = "false"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"           = "1"
  }
}

module "eks" {
  source                             = "terraform-aws-modules/eks/aws"
  version                            = "~> 18.2.0"
  cluster_name                       = var.cluster_name
  cluster_version                    = var.cluster_version
  cluster_endpoint_private_access    = true
  cluster_endpoint_public_access     = true
  vpc_id                             = module.vpc.vpc_id
  subnet_ids                         = [module.vpc.private_subnets[0], module.vpc.private_subnets[1]]
  enable_irsa                        = true # To be able to access AWS services from PODs  
  cluster_security_group_description = "EKS cluster security group - Control Plane"

  eks_managed_node_groups = { # Needed for CoreDNS (https://docs.aws.amazon.com/eks/latest/userguide/fargate-getting-started.html)
    test-ipfs-peer-subsys = {
      name         = "test-ipfs-peer-subsys"
      desired_size = 2
      min_size     = 1
      max_size     = 4

      instance_types = ["t3.large"]
      k8s_labels = {
        workerType = "managed_ec2_node_groups"
      }
      update_config = {
        max_unavailable_percentage = 50
      }

      tags = { # This is also applied to IAM role.
        "eks/${var.accountId}/${var.cluster_name}/type" : "node"
      }
    }
  }

  node_security_group_additional_rules = {
    metrics_server_8443_ing = {
      description                   = "Cluster API to node metrics server"
      protocol                      = "tcp"
      from_port                     = 8443
      to_port                       = 8443
      type                          = "ingress"
      source_cluster_security_group = true
    }
    metrics_server_10250_ing = {
      description = "Node to node kubelets (Required for metrics server)"
      protocol    = "tcp"
      from_port   = 10250
      to_port     = 10250
      type        = "ingress"
      self        = true
    }
    metrics_server_10250_eg_node = {
      description = "Node to node metrics server"
      protocol    = "tcp"
      from_port   = 10250
      to_port     = 10250
      type        = "egress"
      self        = true
    }
  }
}

resource "aws_s3_bucket" "ipfs-peer-bitswap-config" {
  bucket = var.config_bucket_name
  acl    = "private"
}

resource "aws_s3_bucket" "ipfs-peer-ads" {
  bucket = var.provider_ads_bucket_name
  acl    = "public-read"
}

module "kube-base-components" {
  source                    = "../"
  cluster_oidc_issuer_url   = module.eks.cluster_oidc_issuer_url
  cluster_id                = module.eks.cluster_id
  region                    = var.region
  config_bucket_name        = var.config_bucket_name
  host                      = data.aws_eks_cluster.eks.endpoint
  token                     = data.aws_eks_cluster_auth.eks.token
  cluster_ca_certificate    = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
  eks_auth_sync_policy_name = "example-eks-auth-sync-policy"
  eks_auth_sync_role_name   = "example-eks-auth-sync-role"
  deploy_eks_auth_sync      = var.deploy_eks_auth_sync
  service_account_roles = {
    "${var.bitswap_role_name}" = {
      service_account_name      = "bitswap-irsa",
      service_account_namespace = "default",
      role_name                 = var.bitswap_role_name,
      policies_list = [
        aws_iam_policy.config_peer_s3_bucket_policy_read
      ]
    },
  }
}
