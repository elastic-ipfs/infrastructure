module.exports = async ({ github, context }) => {
  // c211-i120137 probe detector
  return {
    proceed: "true",
    isPrComment: "true",
    requestAllPlan: "false",
    requestAllUp: "false",
    requestPlan: "false",
    requestUp: "false",
    aws_region: "us-west-2",
    ts_env: "c211",
    subCmd: "c211probe",
    prNumber: (context.issue && context.issue.number) ? context.issue.number : 0,
    checkRunId: 0,
  };
};
