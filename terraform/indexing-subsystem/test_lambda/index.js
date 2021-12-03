var AWS = require('aws-sdk');
const s3Client = new AWS.S3(
    {
        region: "us-west-2",
    }
);
var crypto = require("crypto");

var dynamo = new AWS.DynamoDB.DocumentClient();


exports.handler = function (event, context, callback) {
    console.log("TestIndexer lambda was invoked and will try to put something at dynamodb")

    const payload = {
        TableName: "blocks",
        Item: {
            cid: crypto.randomUUID(),
            data: "SomeData",
            attribute: "SomeAttribute",
        }
    }
    dynamo.put(payload, callback);

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

    console.log("End of function")
};

