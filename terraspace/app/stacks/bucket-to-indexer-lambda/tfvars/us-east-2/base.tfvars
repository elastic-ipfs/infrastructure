bucket = (
    {
        bucket  = "dotstorage-prod-0"
        arn     = "arn:aws:s3:::dotstorage-prod-0"
        id      = "dotstorage-prod-0"
    }
)
node_env                               = "<%= expansion(':ENV') %>"
indexing_stack_region                  = "us-west-2"
indexing_stack_sqs_indexer_topic_url   = "<%= output('indexing.sqs_indexer_topic', mock: {}}).to_ruby['url'] %>"
indexing_stack_sqs_indexer_policy_send = <%= output('indexing.sqs_indexer_policy_send', mock: {}) %>
