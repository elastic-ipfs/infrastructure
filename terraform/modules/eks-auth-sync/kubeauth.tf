
resource "kubernetes_role" "eksauth" {
  count = var.deploy_eks_auth_sync ? 1 : 0
  metadata {
    name = "aws-auth-editor"
    namespace = var.namespace
    labels = {
      k8s-app = "aws-auth-sync"
    }
  }
  rule {
    api_groups      = [""]
    resources       = ["configmaps"]
    resource_names  = ["aws-auth"]
    verbs           = ["get", "update", "create"]
  }
}

resource "kubernetes_role" "eksauth-system" {
  count = var.deploy_eks_auth_sync && var.namespace != "kube-system" ? 1 : 0
  metadata {
    name = "aws-auth-editor"
    namespace = "kube-system"
    labels = {
      k8s-app = "aws-auth-sync"
    }
  }
  rule {
    api_groups      = [""]
    resources       = ["configmaps"]
    resource_names  = ["aws-auth"]
    verbs           = ["get", "update", "create"]
  }
}

resource "kubernetes_role_binding" "eksauth" {
  count = var.deploy_eks_auth_sync ? 1 : 0
  metadata {
    name      = "eks-auth-sync"
    namespace = var.namespace
    labels = {
      k8s-app = "eks-auth-sync"
    }
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = "aws-auth-editor"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "${local.serviceAccountName}"
    namespace = var.namespace
  }
}

resource "kubernetes_role_binding" "eksauth-system" {
  count = var.deploy_eks_auth_sync && var.namespace != "kube-system" ? 1 : 0
  metadata {
    name      = "eks-auth-sync"
    namespace = "kube-system"
    labels = {
      k8s-app = "eks-auth-sync"
    }
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = "aws-auth-editor"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "${local.serviceAccountName}"
    namespace = var.namespace
  }
}

resource "kubernetes_service_account" "eksauth" {
  metadata {
    name = "${local.serviceAccountName}"
    namespace = var.namespace
    labels = {
      k8s-app = "eks-auth-sync"
    }
    annotations = {
      "eks.amazonaws.com/role-arn" = module.iam_oidc_eks_auth_sync.iam_role_arn
      # "eks.amazonaws.com/role-arn" = replace("arn:aws:iam::account_id:role/${local.serviceAccountName}","account_id",local.account_id)
    }
  }
}
