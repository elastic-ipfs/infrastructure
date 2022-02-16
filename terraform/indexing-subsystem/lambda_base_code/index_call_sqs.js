const AWS = require('aws-sdk')
const sqs = new AWS.SQS({
  apiVersion: '2012-11-05',
  region: 'us-west-2',
})

exports.handler = (event, context, callback) => {
  // Setup the sendMessage parameter object
  const sqsParams = {
    MessageBody: JSON.stringify({
      order_id: 1234,
      date: new Date().toISOString(),
    }),
    // QueueUrl: `https://sqs.us-east-1.amazonaws.com/${accountId}/${queueName}`
    QueueUrl: `https://sqs.us-west-2.amazonaws.com/505595374361/publishing`,
  }
  sqs.sendMessage(sqsParams, (err, data) => {
    if (err) {
      console.log('Error', err)
    } else {
      console.log('Successfully added message', data.MessageId)
      callback(null, 'great success')
    }
  })
}
