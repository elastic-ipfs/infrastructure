const { S3Client, ListObjectsV2Command } = require('@aws-sdk/client-s3')
const config = require('./config.js')
const retryWrapper = require('./retry-wrapper.js')
const sqsMessageSender = require('./sqs-message-sender.js')
const fs = require('fs')

const S3client = new S3Client({
  region: config.s3clientAWSRegion
})

async function* listAllKeys(opts) {
  opts = { ...opts }
  let firstRun = true
  do {
    if (firstRun && config.nextContinuationToken) {
      // Continue where it left of in case of restarting script
      opts.ContinuationToken = config.nextContinuationToken
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
  Bucket: config.sourceBucketName,
}

if (config.s3prefix) {
  opts.Prefix = config.s3prefix
}

fileCount = 0
messageSentCount = 0

async function main() {
  console.log('Starting to process all keys from ' + opts.Bucket)
  const start = Date.now()
  for await (const data of listAllKeys(opts)) {
    await new Promise((resolve) => setTimeout(resolve, config.nextPageAwait))
    for (const object of data.Contents) {
      await handleObject(object)
    }
  }
  const duration = Date.now() - start
  console.log(
    `Finished processing all keys from ${opts.Bucket}. ${fileCount} files were processed and ${messageSentCount} messages were published to queue ${config.sqsQueueUrl}. Processing time(ms): ${duration}`,
  )
}

async function handleObject(object) {
  if (object.Key.endsWith(config.s3suffix)) {
    try {
      const message = `{"skipExists":true, "body": "${config.s3clientAWSRegion}/${opts.Bucket}/${object.Key}" }` // ex: {"skipExists":true, "body":  us-east-2/dotstorage-prod-0/xxxxx.car }
      await new Promise((resolve) => setTimeout(resolve, config.fileAwait))
      fileCount++
      console.log(message)
      console.log(
        `Still processing... Current status: ${fileCount} files were processed and ${messageSentCount} messages were published`,
      )
      if (config.readOnlyMode == 'disabled') {
        success = sqsMessageSender.sendIndexSQSMessage(message)
        if (success) messageSentCount++
      }
    } catch (e) {
      // Don't fail loop over one errored file
      console.error(`message ${message} has failed to be processed`)
      console.error(e.message)
    }
  }
}

main()
