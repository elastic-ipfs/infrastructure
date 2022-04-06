module.exports = async ({github, context}) => {
  const {owner, repo} = context.repo
  const { CHECK_RUN_ID, RESULT, GIT_REF } = process.env
  const res = await github.rest.checks.update({
    owner,
    repo,
    check_run_id: CHECK_RUN_ID,
    conclusion: RESULT,
    details_url: `${context.serverUrl}/${owner}/${repo}/actions/runs/${context.runId}`,
    external_id: `${context.runId}`,
    output: {
      title: "Terraspace Comment Check",
      summary: `[Action Run Log](${context.serverUrl}/${owner}/${repo}/actions/runs/${context.runId})`,
      // TODO could add command output to `text`
      text: "Finished"
    }
  })

  let commitState
  if (["success", "skipped"].includes(RESULT)) {
    commitState = "success"
  } else if (["failure", "action_required", "neutral", "stale"].includes(RESULT)) {
    commitState = "failure"
  } else {
    commitState = "error"
  }

  const commitStatusRes = await github.rest.repos.createCommitStatus({
    owner,
    repo,
    sha: GIT_REF,
    state: commitState,
    target_url: `${context.serverUrl}/${owner}/${repo}/actions/runs/${context.runId}`,
    description: `Terraspace Result: ${RESULT}`,
    context: "Terraspace / pr-comment"
  });

  return res
}
