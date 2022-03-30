const { S3Client, ListObjectsV2Command } = require('@aws-sdk/client-s3')
const { SQSClient, SendMessageCommand } = require('@aws-sdk/client-sqs')

const S3client = new S3Client()
const SQSclient = new SQSClient()

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
  Prefix: 'raw/',
}
fileCount = 0
messageSentCount = 0

async function sendIndexSQSMessage(message) {
  const command = new SendMessageCommand({
    MessageBody: message,
    QueueUrl: process.env.SQS_QUEUE_URL,
  })

  try {
    const data = await SQSclient.send(command)
    console.log('Success', data.MessageId)
    messageSentCount++
  } catch (error) {
    console.error('Error', error)
  }
}

async function main() {
  console.log('Starting to process all keys from ' + opts.Bucket)
  const start = Date.now
  for await (const data of listAllKeys(opts)) {
    for (const object of data.Contents) {
      fileCount++
      const message = `${opts.Bucket}/${object.Key}`
      console.log(message)
      // sendIndexSQSMessage(message)
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
