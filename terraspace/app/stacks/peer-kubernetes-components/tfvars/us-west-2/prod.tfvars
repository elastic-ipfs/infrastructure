bitswap_peer_namespace  = "bitswap-peer"
# TODO: Understand why (and if we actually need) 'sqs_multihashes_policy_send' here
service_account_roles = {
    "bitswap_peer_subsystem_role" = {
      service_account_name      = "bitswap-irsa",
      role_name                 = "bitswap_peer_subsystem_role",
      policies_list = [
        <%= output('shared.dynamodb_blocks_policy', mock: {}) %>,
        <%= output('shared.sqs_multihashes_policy_send', mock: {}) %>,
        <%= output('shared.s3_config_peer_bucket_policy_read', mock: {}) %>,
        <%= output('shared.s3_dotstorage_policy_read', mock: {}) %>,
        <%= output('shared.dynamodb_v1_cars_policy', mock: {}) %>,
        <%= output('shared.dynamodb_v1_blocks_policy', mock: {}) %>,
        <%= output('shared.dynamodb_v1_link_policy', mock: {}) %>,
        <%= output('indexing.sqs_indexer_policy_send', mock: {}) %>, # TODO: Remove that after recovery (v0 to v1 tables) is finished
        <%= output('peer.dynamodb_config_policy', mock: {}) %>,
      ]
    }
}
eks_auth_sync_role_name        = "eks-auth-sync-role"
eks_auth_sync_policy_name      = "eks-auth-sync-policy"
cluster_autoscaler_role_name   = "IPFSClusterEKSAutoscalerRole"
cluster_autoscaler_policy_name = "eks-cluster-autoscaler-policy"
