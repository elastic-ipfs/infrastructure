const { S3Client, ListObjectsV2Command } = require('@aws-sdk/client-s3')
const sqsMessageSender = require('./sqs-message-sender.js')

const S3client = new S3Client()

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
}
fileCount = 0
messageSentCount = 0

async function main() {
  console.log('Starting to process all keys from ' + opts.Bucket)
  const start = Date.now
  for await (const data of listAllKeys(opts)) {
    for (const object of data.Contents) {
      fileCount++
      const message = `${process.env.AWS_REGION}/${opts.Bucket}/${object.Key}`// ex: us-east-2/dotstorage-prod-0/xxxxx.car
      console.log(message)
      if (process.env.READ_ONLY_MODE == 'disabled') {
        success = sqsMessageSender.sendIndexSQSMessage(message)
        if (success) messageSentCount++
      }
    }
  }
  const duration = Date.now() - start
  console.log(
    `Finished processing all keys from ${0}. ${1} files were processed and ${2} messages were published to Index SNS. Processing time(ms): ${3}`,
    opts.Bucket,
    fileCount,
    messageSentCount,
    duration,
  )
}

main()
