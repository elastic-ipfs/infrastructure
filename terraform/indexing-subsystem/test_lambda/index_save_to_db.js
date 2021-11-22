var AWS = require('aws-sdk');
var crypto = require ("crypto");
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
    console.log("End of function")
};
