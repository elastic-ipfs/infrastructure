module.exports = async ({github, context}) => {
  const ref = process.env.GIT_REF
  const {owner, repo} = context.repo
  const result = {
    proceed: "true",
    isPrComment: "false",
    requestAllPlan: "true",
    requestAllUp: "false",
    requestPlan: "false",
    requestUp: "false",
  }
  if (['issue_comment'].includes(context.eventName)) {
    result.proceed = "false"
    if (context.payload.issue?.pull_request) {
      result.isPrComment = "true"
      const { number } = context.issue
      result.prNumber = number
      const body = context.payload.comment.body.toLowerCase().trim()
      const commandArray = body.split(/\s+/)
      // Valid Commands:
      // - AWS_REGION=<value> TS_ENV=<value> terraspace all plan
      // - AWS_REGION=<value> TS_ENV=<value> terraspace all up
      // - AWS_REGION=<value> TS_ENV=<value> terraspace plan [stack]
      // - AWS_REGION=<value> TS_ENV=<value> terraspace up [stack]
      if (commandArray[2] === "terraspace" && commandArray.length === 5) {
        result.program = "terraspace"
        const createStatusChecks = async () => {
          const res = await github.rest.checks.create({
            owner,
            repo,
            status: "in_progress",
            name: "PR Comment",
            head_sha: ref,
            details_url: `${context.serverUrl}/${owner}/${repo}/actions/runs/${context.runId}`,
            external_id: `${context.runId}`,
            output: {
              title: "Terraspace Comment Check",
              summary: `[Action Run Log](${context.serverUrl}/${owner}/${repo}/actions/runs/${context.runId})`,
              text: `Check in progress... For details see the [Action Run Log](${context.serverUrl}/${owner}/${repo}/actions/runs/${context.runId})`
            }
          });
          // console.log(`res = ${JSON.stringify(res)}`)
          result.checkRunId = res.data.id

          const commitStatusRes = await github.rest.repos.createCommitStatus({
            owner,
            repo,
            sha: ref,
            state: "pending",
            target_url: `${context.serverUrl}/${owner}/${repo}/actions/runs/${context.runId}`,
            description: "Terraspace Comment Check",
            context: "Terraspace / pr-comment"
          });

          result.commitStatusId = commitStatusRes.data.id
          // console.log(`commitStatusRes = ${JSON.stringify(commitStatusRes)}`)
        }
        if (commandArray[1] === "all" && ["plan", "up"].includes(commandArray[2])) {
          await createStatusChecks()

          result.proceed = "true"
          result.cmd = "all"
          result.subCmd = commandArray[2]

          result.requestAllUp = result.subCmd === "up" ? "true" : "false"
          result.requestAllPlan = result.subCmd === "plan" ? "true" : "false"
        } else if (["plan", "up"].includes(commandArray[1])) {
          await createStatusChecks()

          result.proceed = "true"
          result.cmd = commandArray[1]
          result.subCmd = commandArray[2]

          result.requestUp = result.cmd === "up" ? "true" : "false"
          result.requestPlan = result.cmd === "plan" ? "true" : "false"
          result.requestAllPlan = "false"
        }
      }
    }
  }
  return result
}
