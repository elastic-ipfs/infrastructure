const { S3 } = require('aws-sdk')
const s3 = new S3()

async function* listAllKeys(opts) {
  opts = { ...opts }
  do {
    const data = await s3.listObjectsV2(opts).promise()
    opts.ContinuationToken = data.NextContinuationToken
    yield data
  } while (opts.ContinuationToken)
}

const opts = {
  Bucket: process.env.SOURCE_BUCKET_NAME /* required */,
  // ContinuationToken: 'STRING_VALUE',
  // Delimiter: 'STRING_VALUE',
  // EncodingType: url,
  // FetchOwner: true || false,
  // MaxKeys: 'NUMBER_VALUE',
  // Prefix: 'STRING_VALUE',
  // RequestPayer: requester,
  // StartAfter: 'STRING_VALUE'
}

async function main() {
  // using for of await loop
  for await (const data of listAllKeys(opts)) {
    console.log(data.Contents)
  }
}
main()
