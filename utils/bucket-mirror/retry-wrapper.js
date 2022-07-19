const sleep = require('util').promisify(setTimeout)
const retries = process.env.RETRIES ?? 3
const retryDelay = process.env.RETRY_DELAY ?? 100

module.exports.send = async function (client, command) {
  let attempts = 0
  let error
  do {
    try {
      return await client.send(command)
    } catch (err) {
      error = err
      console.debug(
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

function serializeError(e) {
  return `[${e.code || e.constructor.name}] ${e.message}\n${e.stack}`
}

