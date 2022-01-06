exports.handler = (event, context, callback) => {
    console.log('Hello, logs!');
    // callback(null, 'great success');
    callback({
        isBase64Encoded: false,
        body: 'great success',
        headers: {
          'Access-Control-Allow-Origin': '*',
        },
        statusCode: 200,
    });
}
