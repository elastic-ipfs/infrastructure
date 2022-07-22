export SOURCE_BUCKET_NAME=dotstorage-prod-0
export S3_CLIENT_AWS_REGION=us-east-2
export SQS_CLIENT_AWS_REGION=us-west-2
export SQS_QUEUE_URL="https://sqs.us-west-2.amazonaws.com/505595374361/dev-ep-indexer-topic"
export READ_ONLY_MODE="enabled" 
export S3_SUFFIX=".car" 
export LOG_LEVEL="info"
export NODE_ENV="production"
./run-continuously.sh
