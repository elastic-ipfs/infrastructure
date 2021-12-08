# This is a testing script for getting S3 pre-signerd URL
# Replace host with AWS API Gateway provided URL and "hello" with objectname
# curl -v -X POST https://<host>/<version>/<objectname>
curl -v -X POST https://oimh81dkbk.execute-api.us-west-2.amazonaws.com/v2/hello
