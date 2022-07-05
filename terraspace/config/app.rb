# Docs: https://terraspace.cloud/docs/config/reference/
Terraspace.configure do |config|
  config.logger.level = :info
  config.all.exclude_stacks = ["bucket-to-indexer-lambda", "bucket-mirror"]
end
