storage_bucket_names               = [
  "dotstorage-<%= expansion(':ENV') %>-0",
  "dotstorage-<%= expansion(':ENV') %>-1",
  "staging-pickup-basicapistack-carbucket*",
  "nearform-runbook-theorical-staging"
   # Names are used in IAM policy resources, which support wildcards
]
