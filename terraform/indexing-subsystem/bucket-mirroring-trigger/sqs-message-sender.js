const { SQSClient, SendMessageCommand } = require('@aws-sdk/client-sqs')

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
    const data = await SQSclient.send(command)
    console.log('Send Message Success', data.MessageId)
    success = true;
  } catch (error) {
    console.error('Send Message Error', error)
    success = false;
  } finally {
    return success;
  }
}
