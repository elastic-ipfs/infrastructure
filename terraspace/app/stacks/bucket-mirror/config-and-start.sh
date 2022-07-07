Content-Type: multipart/mixed; boundary="//"
MIME-Version: 1.0

--//
Content-Type: text/cloud-config; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="cloud-config.txt"

#cloud-config
cloud_final_modules:
- [scripts-user, always]

--//
Content-Type: text/x-shellscript; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="userdata.txt"

#!/bin/bash
rm /var/lib/cloud/instances/*/sem/config_scripts_user;
## TODO: As I'll be running this to 'ubuntu' user maybe just configuring the 'ubuntu' bashrc? I don't remember if user data runs as ubuntu or as root
echo "export SOURCE_BUCKET_NAME=${source_bucket_name}" >> /etc/environment
echo "export S3_CLIENT_AWS_REGION=${s3_client_aws_region}" >> /etc/environment
echo "export S3_PREFIX=${s3_prefix}" >> /etc/environment
echo "export SQS_CLIENT_AWS_REGION=${sqs_client_aws_region}" >> /etc/environment
echo "export SQS_QUEUE_URL=${sqs_queue_url}" >> /etc/environment
echo "export READ_ONLY_MODE=${read_only_mode}" >> /etc/environment
echo "export FILE_AWAIT=${file_await}" >> /etc/environment
echo "export NEXT_PAGE_AWAIT=${next_page_await}" >> /etc/environment
source /etc/environment
echo "*** ENV VALUES *****"
echo SOURCE_BUCKET_NAME=$SOURCE_BUCKET_NAME
echo "*******************"
./bucket-mirror/run-dotstorage-prod-0.sh
