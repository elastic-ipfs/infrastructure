service_account_roles = {
    "bitswap_peer_subsystem_role" = {
      service_account_name      = "bitswap-irsa",
      service_account_namespace = "bitswap-peer",
      role_name                 = "bitswap_peer_subsystem_role",
      policies_list = [
        <%= output('shared.dynamodb_blocks_policy', mock: {}) %>,
        <%= output('shared.sqs_multihashes_policy_send', mock: {}) %>,
        <%= output('shared.s3_config_peer_bucket_policy_read', mock: {}) %>,
        <%= output('shared.s3_dotstorage_prod_0_policy_read', mock: {}) %>,
      ]
    }
}
