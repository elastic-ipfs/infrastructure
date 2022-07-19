const { S3Client, ListObjectsV2Command } = require('@aws-sdk/client-s3')
const retryWrapper = require('./retry-wrapper.js')
const sqsMessageSender = require('./sqs-message-sender.js')
const fs = require('fs')

const S3client = new S3Client({
  region: process.env.S3_CLIENT_AWS_REGION,
})

async function* listAllKeys(opts) {
  opts = { ...opts }
  let firstRun = true
  do {
    if (firstRun && process.env.NEXT_CONTINUATION_TOKEN) {
      // Continue where it left of in case of restarting script
      opts.ContinuationToken = process.env.NEXT_CONTINUATION_TOKEN
      firstRun = false
    }
    const command = new ListObjectsV2Command(opts)
    const foundObjects = await retryWrapper.send(S3client, command)

    opts.ContinuationToken = foundObjects.NextContinuationToken
    if (opts.ContinuationToken) {
      fs.writeFileSync('./NextContinuationToken', opts.ContinuationToken)
    } else {
      console.log('Last page: empty continuation token!')
    }
    yield foundObjects
  } while (opts.ContinuationToken)
}

const opts = {
  Bucket: process.env.SOURCE_BUCKET_NAME,
}

if (process.env.S3_PREFIX) {
  opts.Prefix = process.env.S3_PREFIX
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
      await handleObject(object)
    }
  }
  const duration = Date.now() - start
  console.log(
    `Finished processing all keys from ${opts.Bucket}. ${fileCount} files were processed and ${messageSentCount} messages were published to queue ${process.env.SQS_QUEUE_URL}. Processing time(ms): ${duration}`,
  )
}

async function handleObject(object) {  
  try {
    const message = `${process.env.S3_CLIENT_AWS_REGION}/${opts.Bucket}/${object.Key}` // ex: us-east-2/dotstorage-prod-0/xxxxx.car
    await new Promise((resolve) => setTimeout(resolve, fileAwait))
    fileCount++
    console.log(message)
    console.log(
      `Still processing... Current status: ${fileCount} files were processed and ${messageSentCount} messages were published`,
    )
    if (process.env.READ_ONLY_MODE == 'disabled') {
      success = sqsMessageSender.sendIndexSQSMessage(message)
      if (success) messageSentCount++
    }
  } catch (e) {
    // Don't fail loop over one errored file
    console.error(`message ${message} has failed to be processed`)
    console.error(e.message)
  }
}

main()
