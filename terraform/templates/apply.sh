valid=$(terraform fmt && terraform validate -json | jq -r .valid)
if [[ $valid = 'true' ]]; then terraform apply -auto-approve; fi