const sqsMessageSender = require('./sqs-message-sender.js')
const process = require('process')
const { logger } = require('./logging')

async function main() {
  const message = process.argv[2]
  logger.info(message)
  sqsMessageSender.sendIndexSQSMessage(message)
}

main()
