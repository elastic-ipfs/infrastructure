const { S3Client, ListObjectsV2Command } = require('@aws-sdk/client-s3')
const sqsMessageSender = require('./sqs-message-sender.js')

const S3client = new S3Client({
  region: process.env.S3_CLIENT_AWS_REGION,
})

async function* listAllKeys(opts) {
  opts = { ...opts }
  do {
    const command = new ListObjectsV2Command(opts)
    const foundObjects = await S3client.send(command)
    opts.ContinuationToken = foundObjects.NextContinuationToken
    yield foundObjects
  } while (opts.ContinuationToken)
}

const opts = {
  Bucket: process.env.SOURCE_BUCKET_NAME,
  Prefix: process.env.S3_PREFIX ? process.env.S3_PREFIX : '/',
  // Prefix: "raw/"
}
const nextPageAwait = process.env.NEXT_PAGE_AWAIT
  ? process.env.NEXT_PAGE_AWAIT
  : 0
const fileAwait = process.env.FILE_AWAIT ? process.env.FILE_AWAIT : 0
fileCount = 0
messageSentCount = 0

async function main() {
  console.log('Starting to process all keys from ' + opts.Bucket)
  const start = Date.now()
  for await (const data of listAllKeys(opts)) {
    await new Promise((resolve) => setTimeout(resolve, nextPageAwait))
    for (const object of data.Contents) {
      await new Promise((resolve) => setTimeout(resolve, fileAwait))
      fileCount++
      const message = `${process.env.S3_CLIENT_AWS_REGION}/${opts.Bucket}/${object.Key}` // ex: us-east-2/dotstorage-prod-0/xxxxx.car
      console.log(message)
      if (process.env.READ_ONLY_MODE == 'disabled') {
        success = sqsMessageSender.sendIndexSQSMessage(message)
        if (success) messageSentCount++
      }
    }
  }

  const duration = Date.now() - start
  console.log(
    `Finished processing all keys from ${opts.Bucket}. ${fileCount} files were processed and ${messageSentCount} messages were published to queue ${process.env.SQS_QUEUE_URL}. Processing time(ms): ${duration}`,
  )
}

main()
