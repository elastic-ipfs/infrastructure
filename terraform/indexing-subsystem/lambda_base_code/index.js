exports.handler = async (event, context, callback) => {
  console.log('Hello, logs!')
  // callback(null, 'great success');
  return {
    isBase64Encoded: false,
    body: 'great success',
    headers: {
      'Access-Control-Allow-Origin': '*',
    },
    statusCode: 200,
  }
}
