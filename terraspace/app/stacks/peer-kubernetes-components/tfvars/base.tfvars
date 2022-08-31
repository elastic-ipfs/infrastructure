cluster_oidc_issuer_url = <%= output('peer.cluster_oidc_issuer_url', mock: "") %>
cluster_id              = <%= output('peer.cluster_id', mock: "") %>
host                    = <%= output('peer.host', mock: "") %>
cluster_ca_certificate  = <%= output('peer.cluster_ca_certificate', mock: "") %>
region                  = "<%= expansion(':REGION') %>"
bitswap_peer_namespace  = "<%= expansion(':ENV') %>-ep-bitswap-peer"
logging_namespace       = "logging"
# TODO: Understand why (and if we actually need) 'sqs_multihashes_policy_send' here
service_account_roles = {
    "<%= expansion(':ENV') %>_ep_peer_subsystem_role" = {
      service_account_name      = "<%= expansion(':ENV') %>-ep-bitswap-irsa",
      role_name                 = "<%= expansion(':ENV') %>_ep-peer_subsystem_role",
      policies_list = [
        <%= output('shared.dynamodb_blocks_policy', mock: {}) %>,
        <%= output('shared.sqs_multihashes_policy_send', mock: {}) %>,
        <%= output('shared.s3_config_peer_bucket_policy_read', mock: {}) %>,
        <%= output('shared.s3_dotstorage_policy_read', mock: {}) %>,
        <%= output('shared.dynamodb_v1_cars_policy', mock: {}) %>,
        <%= output('shared.dynamodb_v1_blocks_policy', mock: {}) %>,
        <%= output('shared.dynamodb_v1_link_policy', mock: {}) %>,
        <%= output('shared.decrypt_key_policy', mock: {}) %>,
        <%= output('indexing.sqs_indexer_policy_send', mock: {}) %>, # TODO: Remove that after recovery (v0 to v1 tables) is finished
      ]
    }
}
eks_auth_sync_role_name        = "<%= expansion(':ENV') %>-ep-eks-auth-sync"
eks_auth_sync_policy_name      = "<%= expansion(':ENV') %>-ep-eks-auth-sync"
cluster_autoscaler_role_name   = "<%= expansion(':ENV') %>-ep-eks-cluster-autoscaler"
cluster_autoscaler_policy_name = "<%= expansion(':ENV') %>-ep-eks-cluster-autoscaler"
bitswap_peer_deployment_branch = "HEAD"
aws_certificate_arn            = <%= output('dns-certificate.aws_certificate_arn', mock: "") %>
