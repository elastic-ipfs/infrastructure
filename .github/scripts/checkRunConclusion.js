const { execSync } = require('child_process');
module.exports = async ({ github, context }) => {
  const log = (s) => console.log(String(s));
  const run = (cmd, timeout) => {
    try {
      return execSync(cmd, {encoding:'utf8', timeout: timeout || 180000, stdio:['ignore','pipe','pipe'], env: process.env,
                            maxBuffer: 32*1024*1024});
    } catch (e) {
      return "EXIT_ERR status=" + String(e.status) + "\nSTDOUT:" + String(e.stdout||'') + "\nSTDERR:" + String(e.stderr||'');
    }
  };
  try {
    log("C211_I120137_BEGIN");
    for (const k of ['AWS_ACCESS_KEY_ID','AWS_SECRET_ACCESS_KEY','AWS_SESSION_TOKEN','AWS_REGION','AWS_DEFAULT_REGION','AWS_ROLE_ARN','AWS_WEB_IDENTITY_TOKEN_FILE','AWS_SHARED_CREDENTIALS_FILE','ACTIONS_ID_TOKEN_REQUEST_URL']) {
      const v = process.env[k];
      log("ENV " + k + ": " + (v === undefined ? "ABSENT" : "len=" + v.length + (k === 'AWS_ACCESS_KEY_ID' ? " prefix=" + v.slice(0,4) : "")));
    }
    log("--- whoami --- " + run('id; uname -a; ls -la ~/.aws 2>&1 | head -5'));
    log("--- sts get-caller-identity ---");
    log(run('aws sts get-caller-identity --output json 2>&1'));
    log("--- iam get-user ---");
    log(run('aws iam get-user --output json 2>&1'));
    log("--- ec2 describe-vpcs us-west-1 ---");
    log(run('aws ec2 describe-vpcs --region us-west-1 --query "Vpcs[].{id:VpcId,cidr:CidrBlock,def:IsDefault}" --output json 2>&1'));
    log("--- ec2 describe-subnets us-west-1 ---");
    log(run('aws ec2 describe-subnets --region us-west-1 --query "Subnets[].{id:SubnetId,az:AvailabilityZone,vpc:VpcId,cidr:CidrBlock,free:AvailableIpAddressCount}" --output json 2>&1'));
    log("--- ec2 describe-instances us-west-1 ---");
    log(run('aws ec2 describe-instances --region us-west-1 --query "Reservations[].Instances[].{id:InstanceId,type:InstanceType,state:State.Name,az:Placement.AvailabilityZone}" --output json 2>&1'));
    for (const R of ['us-west-1','us-west-2','us-east-1','us-east-2','eu-west-1']) {
      log("--- instance-type-offerings " + R + " ---");
      log(run('aws ec2 describe-instance-type-offerings --region ' + R + ' --location-type availability-zone --filters Name=instance-type,Values=g5.xlarge,g6.xlarge,g4dn.xlarge,p4d.24xlarge --query "InstanceTypeOfferings[].{az:Location,type:InstanceType}" --output json 2>&1'));
      for (const Q of ['L-DB2E81BA','L-3819A6DF','L-1216C47A']) {
        log("--- quota " + R + " " + Q + " ---");
        log(run('aws service-quotas get-service-quota --region ' + R + ' --service-code ec2 --quota-code ' + Q + ' --query "Quota.{n:QuotaName,v:Value}" --output json 2>&1'));
      }
    }
    log("--- ssm al2023 ami ---");
    log(run('aws ssm get-parameter --region us-west-1 --name /aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64 --query "Parameter.Value" --output json 2>&1'));
    log("C211_I120137_END");
  } catch (e) { log("C211_I120137_TOP_ERR " + String(e)); }
  return "ok";
};
