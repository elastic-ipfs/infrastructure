export SOURCE_BUCKET_NAME=dotstorage-dev-0
export S3_CLIENT_AWS_REGION=us-east-2
export SQS_CLIENT_AWS_REGION=us-west-2
export SQS_QUEUE_URL="https://sqs.us-west-2.amazonaws.com/505595374361/dev-ep-indexer-topic"
export READ_ONLY_MODE="disabled" 
./run-continuously.sh
