const { SQSClient, SendMessageCommand } = require('@aws-sdk/client-sqs')
const retryWrapper = require('./retry-wrapper.js')

const SQSclient = new SQSClient({
  region: process.env.SQS_CLIENT_AWS_REGION,
})

module.exports.sendIndexSQSMessage = async function(message) {
  let success = false;
  const command = new SendMessageCommand({
    MessageBody: message,
    QueueUrl: process.env.SQS_QUEUE_URL,
  })

  try {
    const data = await retryWrapper.send(SQSclient, command)
    console.log('Send Message Success', data.MessageId)
    success = true;
  } catch (error) {
    console.error('Send Message Error', error)
    success = false;
  } finally {
    return success;
  }
}
