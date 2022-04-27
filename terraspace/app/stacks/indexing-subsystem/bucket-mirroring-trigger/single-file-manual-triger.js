const sqsMessageSender = require('./sqs-message-sender.js')
const process = require('process')

async function main() {
  const message = process.argv[2]
  console.log(message)
  sqsMessageSender.sendIndexSQSMessage(message)
}

main()
