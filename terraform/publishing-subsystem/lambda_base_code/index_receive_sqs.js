const AWS = require('aws-sdk')
const sqs = new AWS.SQS({
  apiVersion: '2012-11-05',
  region: 'us-west-2',
})

exports.handler = (event, context, callback) => {
  // Setup the sendMessage parameter object
  const queueUrl = `https://sqs.us-west-2.amazonaws.com/505595374361/multihashes-topic`
  const sqsParams = {
    QueueUrl: queueUrl
  }
  sqs.receiveMessage(sqsParams, (err, data) => {
    if (err) {
      console.log('Error', err)
    } else {
      console.log(data)
      sqs.deleteMessage(
        {
          QueueUrl: queueUrl,
          ReceiptHandle: data.Messages[0].ReceiptHandle,
        },
        function (err, data) {
          err && console.log(err)
        },
      )
      callback(null, 'great success')
    }
  })
}
