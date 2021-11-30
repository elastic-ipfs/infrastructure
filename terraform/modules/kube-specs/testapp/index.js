const AWS = require('aws-sdk')
const docClient = new AWS.DynamoDB.DocumentClient(
    {
        region: "us-west-2",
    }
)

var params = {
    TableName: 'blocks',
    Key: { 'cid': '44c8cbf4-5e56-4c59-81a0-9b06eec31f45' }
}

docClient.get(params, function (err, data) {
    if (err) console.log(err)
    else console.log(data)
})

setTimeout(function () { }, 30000);
