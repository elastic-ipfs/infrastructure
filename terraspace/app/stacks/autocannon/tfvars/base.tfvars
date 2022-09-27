## TODO: https://www.notion.so/IPFS-Elastic-Provider-log-868adc5d3a8f4094bf5cd0eb26679c15?v=6224285d255941269d9a8aee6b6c6171&p=18fa9755d88e4763afb86848735a5c43
subnet_id         = "subnet-06ff59acbc0a34548" # management-ipfs-elastic public subnet
security_group_id = "sg-0da8ec52f04fcca8d"
key_name          = "management-ipfs-elastic"
##
autocannon_ami_name = "autocannon"
source_bucket_name     = "dotstorage-<%= expansion(':ENV') %>-0"
ec2_instance_name      = "<%= expansion(':ENV') %>-ep-autocannon"
s3_client_aws_region   = "us-east-2"
sqs_queue_url          = "<%= output('indexing.sqs_indexer_topic', mock: '').to_ruby['url'] %>"
s3_suffix              = ".car"
log_after_value_files  = 10000
policies_list = [
  <%= output('shared.s3_dotstorage_policy_read', mock: {}) %>,
  <%= output('indexing.sqs_indexer_policy_send', mock: {}) %>,
]
read_only_mode     = "disabled"
