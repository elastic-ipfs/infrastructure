# Docs: https://terraspace.cloud/docs/config/reference/
Terraspace.configure do |config|
  config.logger.level = :info
  config.all.exclude_stacks = ["bucket-to-indexer-lambda", "dns", "publishing"] # DNS depends on Bitswap Peer ELB URL (Managed by Kubernetes). Publishing depends on DNS
end
