# Configure local kubeconfig_output_path
terraform apply -var kubeconfig_output_path=$HOME/.kube/config
terraform destroy -var kubeconfig_output_path=$HOME/.kube/config
