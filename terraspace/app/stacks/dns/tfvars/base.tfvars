### Deprecated
create_zone                     = false
aws_domain_name                 = "ipfs-elastic-provider-aws.com"
deprecated_route53_subdomains_bitwsap_loadbalancer = "<%= expansion(':ENV.peer') %>"
###
cf_domain_name = <%= output('dns-certificate.cf_domain_name', mock: '') %>
bitswap_peer_record = <%= output('dns-certificate.bitswap_peer_record', mock: {}) %>
# Dependency is not mapped based on outputs, so explicitly call out the dependency
# bitswap_load_balancer_dns variable will always be wrong when starting this environment from scratch. Remember to update it.
<% depends_on('peer-kubernetes-components') %>
