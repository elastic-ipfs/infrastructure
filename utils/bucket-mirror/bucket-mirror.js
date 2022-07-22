const { S3Client, ListObjectsV2Command } = require('@aws-sdk/client-s3')
const config = require('./config.js')
const retryWrapper = require('./retry-wrapper.js')
const sqsMessageSender = require('./sqs-message-sender.js')
const fs = require('fs')
const { logger } = require('./logging')

const S3client = new S3Client({
  region: config.s3clientAWSRegion,
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
      logger.info('Last page: empty continuation token!')
    }
    yield foundObjects
  } while (opts.ContinuationToken)
}

const opts = {
  Bucket: config.sourceBucketName,
  // MaxKeys: 3,
}

if (config.s3prefix) {
  opts.Prefix = config.s3prefix
}

fileCount = 0
skippedFileSuffixCount = 0
messageSentCount = 0

function getStatusText(fileCount, messageSentCount, skippedFileSuffixCount) {
  return `${fileCount} files were processed. ${messageSentCount} messages were published. ${skippedFileSuffixCount} were skipped because didn't match suffix "${config.s3suffix}"`
}

async function main() {
  logger.info('Starting to process all keys from ' + opts.Bucket)
  const start = Date.now()
  for await (const data of listAllKeys(opts)) {
    for (const object of data.Contents) {
      await handleObject(object)
    }
  }
  const duration = Date.now() - start
  logger.info(
    `Finished processing all keys from ${opts.Bucket}. ${getStatusText(
      fileCount,
      messageSentCount,
      skippedFileSuffixCount,
    )}`,
  )
}

async function handleObject(object) {
  fileCount++
  if (object.Key.endsWith(config.s3suffix)) {
    try {
      const message = `{"skipExists":true, "body": "${config.s3clientAWSRegion}/${opts.Bucket}/${object.Key}" }` // ex: {"skipExists":true, "body":  us-east-2/dotstorage-prod-0/xxxxx.car }
      // const message = `${config.s3clientAWSRegion}/${opts.Bucket}/${object.Key}` // ex: us-east-2/dotstorage-prod-0/xxxxx.car
      await new Promise((resolve) => setTimeout(resolve, config.fileAwait))
      logger.debug(message)
      if (config.readOnlyMode == 'disabled') {
        success = sqsMessageSender.sendIndexSQSMessage(message)
        if (success) messageSentCount++
      }
      if (fileCount % config.logAfterValueFiles == 0) {
        // Reduce amount of logs
        logger.info(
          `Still processing... Current status: ${getStatusText(
            fileCount,
            messageSentCount,
            skippedFileSuffixCount,
          )}`,
        )
      }
    } catch (e) {
      // Don't fail loop over one errored file
      console.error(`message ${message} has failed to be processed`)
      console.error(e.message)
    }
  } else {
    skippedFileSuffixCount++
    logger.debug(
      `Skipping object ${object.Key} because of unmatched suffix. Expected: ${config.s3suffix}`,
    )
  }
}

main()
