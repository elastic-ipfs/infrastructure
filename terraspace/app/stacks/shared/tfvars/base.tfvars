# This follows current namespacing pattern: https://filecoinproject.slack.com/archives/C02BZPRS9HP/p1650986348274689?thread_ts=1646828696.183769&cid=C02BZPRS9HP
config_bucket_name     = "<%= expansion(':REGION-:ENV') %>-ep-bitswap-config"
multihashes_topic_name = "<%= expansion(':ENV') %>-ep-multihashes-topic"
cars_table_name        = "<%= expansion(':ENV') %>-ep-cars"
blocks_table_name      = "<%= expansion(':ENV') %>-ep-blocks"
v1_cars_table = {
  name     = "<%= expansion(':ENV') %>-ep-v1-cars"
  hash_key = "path"
}
v1_blocks_table = {
  name     = "<%= expansion(':ENV') %>-ep-v1-blocks"
  hash_key = "multihash"
}
v1_link_table = {
  name      = "<%= expansion(':ENV') %>-ep-v1-blocks-cars-position"
  hash_key  = "blockmultihash"
  range_key = "carpath"
}
multihashes_send_policy_name       = "<%= expansion(':ENV') %>-ep-sqs-multihashes-send"
multihashes_receive_policy_name    = "<%= expansion(':ENV') %>-ep-sqs-multihashes-receive"
multihashes_delete_policy_name     = "<%= expansion(':ENV') %>-ep-sqs-multihashes-delete"
config_bucket_read_policy_name     = "<%= expansion(':ENV') %>-ep-s3-config-peer-bucket-read"
dotstorage_bucket_read_policy_name = "<%= expansion(':ENV') %>-ep-s3-dotstorage-buckets-read"
dotstorage_bucket_name             = "dotstorage-<%= expansion(':ENV') %>-0"
dotstorage_bucket_1_name           = "dotstorage-<%= expansion(':ENV') %>-1"
