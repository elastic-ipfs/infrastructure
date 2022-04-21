
export SOURCE_BUCKET_NAME=dotstorage-prod-0
export S3_CLIENT_AWS_REGION=us-east-2
export SQS_CLIENT_AWS_REGION=us-west-2
export READ_ONLY_MODE="disabled" 
export SQS_QUEUE_URL="https://sqs.us-west-2.amazonaws.com/505595374361/indexer-topic"
export PREFIX="complete/"
export FILE_AWAIT=100
export NEXT_PAGE_AWAIT=10000 
node bucket-mirror.js
