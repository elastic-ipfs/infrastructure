terraform {
  required_version = ">= 1.0.0"
}

provider "aws" {
  profile = var.profile
  region  = var.region
  default_tags {
    tags = {
      Team       = "NearForm"
      Project    = "AWS-IPFS"
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
  private_subnets      = ["10.4.1.0/24", "10.4.2.0/24"]
  public_subnets       = ["10.4.3.0/24", "10.4.4.0/24", "10.4.5.0/24"]
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
  source                          = "terraform-aws-modules/eks/aws"
  version = "17.24.0" # TODO: Upgrade
  cluster_name                    = var.cluster_name
  cluster_version                 = var.cluster_version
  vpc_id                          = module.vpc.vpc_id
  subnets                         = [module.vpc.private_subnets[0], module.vpc.private_subnets[1]]
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true
  enable_irsa                     = true # To be able to access AWS services from PODs  
  
  # TODO: Solve error when trying to manage_aws_auth. Is trying to always post to "http://localhost/api/v1/namespaces/kube-system/configmaps":
  manage_aws_auth = false
  # cluster_enabled_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"] # Enable for loging
}

module "kube-base-components" {
  source = "../"
  aws_iam_role_policy_list = [ # TODO: These are IAM Roles that services will need.. Here I could create the serviceAccounts (Separated) and then at App specs they point to those (service_account_name)
                               # TODO: Should I create two iam_assumable_role_admin? keep static inside the module that these are two apps. OR outside here I could keep a "list of lists", each generates a different service account.. Cool stuff..
  ]
  cluster_oidc_issuer_url   = module.eks.cluster_oidc_issuer_url
  cluster_oidc_provider_arn = module.eks.oidc_provider_arn
  cluster_id                = module.eks.cluster_id  
  config_bucket_name          = var.config_bucket_name
  kubeconfig_output_path    = module.eks.kubeconfig_filename
  host                      = data.aws_eks_cluster.eks.endpoint
  token                     = data.aws_eks_cluster_auth.eks.token
  cluster_ca_certificate    = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
}

