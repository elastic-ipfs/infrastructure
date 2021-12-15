locals {
  service_account_namespace    = "default"
  service_account_name         = "irsa"
  bitnami_repo                 = "https://charts.bitnami.com/bitnami"
  peer_service_name            = "aws-ipfs-bitswap-peer"
  peer_service_port            = 3000
  peer_service_target_port     = 3000
  provider_service_name        = "aws-ipfs-index-provider"
  provider_service_port        = 3000
  provider_service_target_port = 3000
}
