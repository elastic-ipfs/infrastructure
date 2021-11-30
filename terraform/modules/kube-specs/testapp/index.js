const AWS = require('aws-sdk')
const docClient = new AWS.DynamoDB.DocumentClient(
    {
        region: "us-west-2",
    }
)

var params = {
    TableName: 'NearFormVisibilityTest',
    Key: { 'testKey': '1' }
}

docClient.get(params, function (err, data) {
    if (err) console.log(err)
    else console.log(data)
})
