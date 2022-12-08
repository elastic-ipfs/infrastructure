storage_bucket_names               = [
  "dotstorage-<%= expansion(':ENV') %>-0",
  "dotstorage-<%= expansion(':ENV') %>-1",
  "staging-pickup-basicapistack-carbucket*", # Names are used in IAM policy resources, which support wildcards
]
