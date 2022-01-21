# Add new cluster admin user

Just add these tags to the IAM user/role.

eks/<account-id>/<cluster-name>/username: <name-you-choose>
eks/<account-id>/<cluster-name>/groups: <list-of=groups-separated-by-++-character>


## Example

eks/505595374361/test-ipfs-peer-subsys/username: francisco
eks/505595374361/test-ipfs-peer-subsys/groups: system:masters
