region       = "<%= expansion(':REGION') %>"
cluster_id              = <%= output('peer.cluster_id', mock: "") %>
host                    = <%= output('peer.host', mock: "") %>
cluster_ca_certificate  = <%= output('peer.cluster_ca_certificate', mock: "") %>
