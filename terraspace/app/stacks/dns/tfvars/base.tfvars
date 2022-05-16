create_zone                     = false
aws_domain_name                 = "ipfs-elastic-provider-aws.com"
subdomains_bitwsap_loadbalancer = "peer"

# Dependency is not mapped based on outputs, so explicitly call out the dependency
<% depends_on('peer-kubernetes-components') %>
