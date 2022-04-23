
export SOURCE_BUCKET_NAME=dotstorage-prod-0
export S3_CLIENT_AWS_REGION=us-east-2
export S3_PREFIX="raw/"
export SQS_CLIENT_AWS_REGION=us-west-2
export SQS_QUEUE_URL="https://sqs.us-west-2.amazonaws.com/505595374361/indexer-topic"
export READ_ONLY_MODE="disabled" 
export FILE_AWAIT=2
export NEXT_PAGE_AWAIT=300
for i in $(seq 1 1000); do [ $i -gt 1 ] && sleep 5; export NEXT_CONTINUATION_TOKEN=$(cat NextContinuationToken); echo "Run started at $(date +"%T")" >> run-dotstorage-prod-0.log; node bucket-mirror.js && s=0 && break || s=$?; done; (exit $s)
