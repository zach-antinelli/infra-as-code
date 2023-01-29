output=$(terraform fmt && terraform validate -json)
if [[ $(echo $output | jq -r .valid ) = 'true' ]]; then terraform apply -auto-approve; else echo $output; fi