# Bucket Mirror

This script will send messages to SQS queue for each file that exists in a bucket.


``` sh
export SOURCE_BUCKET_NAME=<source-bucket-name>
export S3_CLIENT_AWS_REGION=<source-bucket-region> # If this is not set you can get 301
export SQS_CLIENT_AWS_REGION=<source-bucket-region> # If this is not set you can get "queue does not exist"
export READ_ONLY_MODE="disabled" # Otherwise it will just read existing files from bucket
export SQS_QUEUE_URL=<SQS-queue-url> 
export PREFIX="foldername/" # Defaults to "/" if no explicitly set. Need to set the ending "/"
export FILE_AWAIT=300 # How long to await between files. Useful for avoiding DB throttling
export NEXT_PAGE_AWAIT=1000 # How long to await after fetching 1000 files. Useful for avoiding DB throttling
```
