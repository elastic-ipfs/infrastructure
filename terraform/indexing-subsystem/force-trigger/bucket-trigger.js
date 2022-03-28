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
}

async function sendIndexSQSMessage(bucketName, fileKey) {
  const message = `${bucketName}/${fileKey}`
  console.log(message)

  const command = new SendMessageCommand({
    MessageBody: message,
    QueueUrl: process.env.SQS_QUEUE_URL,
  })

  try {
    const data = await SQSclient.send(command);
    console.log('Success', data.MessageId)    
  } catch (error) {
    console.error('Error', error)
  } 
}

async function main() {
  for await (const data of listAllKeys(opts)) {
    sendIndexSQSMessage(opts.Bucket, data.Contents[0].Key)
  }
}

main()
