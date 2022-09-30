cluster_id              = <%= output('peer.cluster_id', mock: "") %>
host                    = <%= output('peer.host', mock: "") %>
cluster_oidc_issuer_url = <%= output('peer.cluster_oidc_issuer_url', mock: "") %>
cluster_ca_certificate  = <%= output('peer.cluster_ca_certificate', mock: "") %>
eks_oidc_provider_arn   = <%= output('peer.eks_oidc_provider_arn', mock: "") %>
oidc_provider           = <%= output('peer.oidc_provider', mock: "") %>