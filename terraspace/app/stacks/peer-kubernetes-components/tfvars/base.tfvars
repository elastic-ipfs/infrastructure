cluster_oidc_issuer_url = <%= output('peer.cluster_oidc_issuer_url', mock: "") %>
cluster_id              = <%= output('peer.cluster_id', mock: "") %>
host                    = <%= output('peer.host', mock: "") %>
cluster_ca_certificate  = <%= output('peer.cluster_ca_certificate', mock: "") %>
region                  = "<%= expansion(':REGION') %>"
config_bucket_name      = "<%= output('shared.ipfs_peer_bitswap_config_bucket', mock: {}).to_ruby['id'] %>"
# TODO: Generate token from CLI instead of using sensitive OR just use it as sensitive? (First option seems more secure). Place it in the env variable that will be read here
# TODO: Understand why (and if we actually need) 'sqs_multihashes_policy_send' here
service_account_roles = {
    "<%= expansion(':ENV') %>_ep_peer_subsystem_role" = {
      service_account_name      = "<%= expansion(':ENV') %>-ep-bitswap-irsa",
      service_account_namespace = "<%= expansion(':ENV') %>-ep-peer",
      role_name                 = "<%= expansion(':ENV') %>_ep-peer_subsystem_role",
      policies_list = [
        <%= output('shared.dynamodb_blocks_policy', mock: {}) %>,
        <%= output('shared.sqs_multihashes_policy_send', mock: {}) %>,
        <%= output('shared.s3_config_peer_bucket_policy_read', mock: {}) %>,
        <%= output('shared.s3_dotstorage_prod_0_policy_read', mock: {}) %>,
      ]
    }
}
