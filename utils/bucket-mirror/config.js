const {
  NEXT_CONTINUATION_TOKEN: nextContinuationToken,
  SOURCE_BUCKET_NAME: sourceBucketName,
  S3_CLIENT_AWS_REGION: s3clientAWSRegion,
  S3_PREFIX: s3prefix,
  S3_SUFFIX: s3suffix,
  SQS_CLIENT_AWS_REGION: sqsClientAWSRegion,
  SQS_QUEUE_URL: sqsQueueUrl,
  READ_ONLY_MODE: readOnlyMode,
  NEXT_PAGE_AWAIT: nextPageAwait,
  FILE_AWAIT: fileAwait,
  RETRIES: retries,
  RETRY_DELAY: retryDelay,
} = process.env

module.exports = {
  nextContinuationToken,
  sourceBucketName,
  s3clientAWSRegion,
  s3prefix,
  s3suffix: s3suffix ?? '.car',
  sqsClientAWSRegion,
  sqsQueueUrl,
  readOnlyMode: readOnlyMode ?? 'enabled',
  nextPageAwait: nextPageAwait ?? 0,
  fileAwait: fileAwait ?? 0,
  retries: retries ?? 3,
  retryDelay: retryDelay ?? 100,
}
