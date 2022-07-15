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
export user=ubuntu
export userHomePath="/home/$user"
export envFile="/etc/environment"
echo "export SOURCE_BUCKET_NAME=${source_bucket_name}" >> $envFile
echo "export S3_CLIENT_AWS_REGION=${s3_client_aws_region}" >> $envFile
echo "export S3_PREFIX=${s3_prefix}" >> $envFile
echo "export SQS_CLIENT_AWS_REGION=${sqs_client_aws_region}" >> $envFile
echo "export SQS_QUEUE_URL=${sqs_queue_url}" >> $envFile
echo "export READ_ONLY_MODE=${read_only_mode}" >> $envFile
echo "export FILE_AWAIT=${file_await}" >> $envFile
echo "export NEXT_PAGE_AWAIT=${next_page_await}" >> $envFile
source $envFile
su $user
echo "*************"
echo "SOURCE_BUCKET_NAME=$SOURCE_BUCKET_NAME"
echo "*************"
cd $userHomePath/bucket-mirror
./run-dotstorage-prod-0.sh


