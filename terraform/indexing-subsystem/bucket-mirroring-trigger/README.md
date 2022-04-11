# Running

``` sh
export SOURCE_BUCKET_NAME=<source-bucket-name>
export AWS_REGION=<source-bucket-region> # If this is not set you get 301
export READ_ONLY_MODE="disabled" # Otherwise it will just read existing files from bucket
export SQS_QUEUE_URL=<SQS-queue-url>
node bucket-trigger.js
```
