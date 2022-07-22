const sleep = require('util').promisify(setTimeout)
const config = require('./config.js')
const { logger, serializeError } = require('./logging')

const retries = config.retries
const retryDelay = config.retryDelay

module.exports.send = async function (client, command) {
  let attempts = 0
  let error
  do {
    try {
      return await client.send(command)
    } catch (err) {
      error = err
      logger.debug(
        { command, error: serializeError(err) },
        `Error, attempt ${attempts + 1} / ${retries}`,
      )
    }
    await sleep(retryDelay)
  } while (++attempts < retries)

  logger.error(
    { command, error: serializeError(error) },
    `Cannot send command after ${attempts} attempts`,
  )
  throw new Error('Cannot send command to DynamoDB')
}
