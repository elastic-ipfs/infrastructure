exports.handler = (event, context, callback) => {

    const AWS = require('aws-sdk')
    const sqs = new AWS.SQS(
        {
            apiVersion: '2012-11-05',
            region: "us-west-2"
        }
    );

    // Setup the sendMessage parameter object
    const sqsParams = {       
        QueueUrl: `https://sqs.us-west-2.amazonaws.com/505595374361/multihashes_topic`
    };
    sqs.receiveMessage(sqsParams, (err, data) => {
        if (err) {
            console.log("Error", err);
        } else {
            console.log(data);
            callback(null, 'great success');
        }
    });
}
