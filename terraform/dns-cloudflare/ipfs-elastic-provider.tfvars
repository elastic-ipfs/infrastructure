# TODO: Are we keeping this here? Workflow / Terraspace discussion.
# record = {
#   zone_id = "527a751e662d1464124d11e83c2250ea"
#   # name    = "peer" ## ?
#   # name    = "*.ipfs-elastic-provider.com" ## ?
#   name    = "peer.ipfs-elastic-provider.com" ## That seems like the correct one!
#   value = "peer.ipfs-elastic-provider-aws.com"
# }

records = [
  {
    zone_id = "527a751e662d1464124d11e83c2250ea"
    name    = "api.uploader.ipfs-elastic-provider.com"
    value   = "api.uploader.ipfs-elastic-provider-aws.com"
  },
  {
    zone_id = "527a751e662d1464124d11e83c2250ea"
    name    = "peer.ipfs-elastic-provider.com"
    value   = "peer.ipfs-elastic-provider-aws.com"
    # value = "ad62259e461cc4df986d3d01bd51140f-2139506693.us-west-2.elb.amazonaws.com" # When connected directly it works
  },
  {
    zone_id = "527a751e662d1464124d11e83c2250ea"
    name    = "google.ipfs-elastic-provider.com"
    value   = "google.ipfs-elastic-provider-aws.com"
    # value   = "google.com"
  }
]
