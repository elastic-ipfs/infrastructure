const AWS = require('aws-sdk')
const request = require('request');

const s3Client = new AWS.S3(
    {
        region: "us-west-2",
    }
);
const dyanmoClient = new AWS.DynamoDB.DocumentClient(
    {
        region: "us-west-2",
    }
)

var params = {
    TableName: 'blocks',
    Key: { 'cid': '44c8cbf4-5e56-4c59-81a0-9b06eec31f45' }
}

dyanmoClient.get(params, function (err, data) {
    if (err) console.log(err)
    else console.log(data)
})

var getParams = {
    Bucket: 'ipfs-cars',
    Key: 'testfile.txt'
}

console.log("Will try to get file from bucket...")
s3Client.getObject(getParams, function (err, data) {
    // Handle any error and exit
    if (err)
        return err;

    // No error happened
    // Convert Body from a Buffer to a String
    let objectData = data.Body.toString('utf-8'); // Use the encoding necessary
    console.log(objectData)
});


request('https://www.google.com', null, (err, res, body) => {
    if (err) { return console.log(err); }
    console.log("received answer from google website");
    console.log(body);
});

setTimeout(function () { }, 30000);
