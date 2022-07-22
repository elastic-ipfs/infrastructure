
const { SQSClient, SendMessageCommand } = require('@aws-sdk/client-sqs')
const { logger } = require('./logging')
const config = require('./config.js')
const retryWrapper = require('./retry-wrapper.js')

const SQSclient = new SQSClient({
  region: config.sqsClientAWSRegion,
})

module.exports.sendIndexSQSMessage = async function(message) {
  let success = false;
  const command = new SendMessageCommand({
    MessageBody: message,
    QueueUrl: config.sqsQueueUrl,
  })

  try {
    const data = await retryWrapper.send(SQSclient, command)
    logger.debug('Send Message Success', data.MessageId)
    success = true;
  } catch (error) {
    logger.error('Send Message Error', error)
    success = false;
  } finally {
    return success;
  }
}
