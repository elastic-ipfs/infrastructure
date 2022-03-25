const { S3, SQS } = require('aws-sdk')
const s3 = new S3()
const sqs = new SQS()

async function* listAllKeys(opts) {
  opts = { ...opts }
  do {
    const data = await s3.listObjectsV2(opts).promise()
    opts.ContinuationToken = data.NextContinuationToken
    yield data
  } while (opts.ContinuationToken)
}

const opts = {
  Bucket: process.env.SOURCE_BUCKET_NAME,
  // ContinuationToken: 'STRING_VALUE',
  // Delimiter: 'STRING_VALUE',
  // EncodingType: url,
  // FetchOwner: true || false,
  // MaxKeys: 'NUMBER_VALUE',
  // Prefix: 'STRING_VALUE',
  // RequestPayer: requester,
  // StartAfter: 'STRING_VALUE'
}


async function sendIndexSQSMessage(bucketName, fileKey) {
  const message = `s3://${bucketName}/${fileKey}`
  console.log(message)

  var params = {
    MessageBody: message,
    QueueUrl: process.env.SQS_QUEUE_URL,
  }

  sqs.sendMessage(params, function (err, data) {
    if (err) {
      console.log('Error', err)
    } else {
      console.log('Success', data.MessageId)
    }
  })
}

async function main() {
  for await (const data of listAllKeys(opts)) {
    sendIndexSQSMessage(opts.Bucket, data.Contents[0].Key)
  }
}

main()
