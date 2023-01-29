$valid = (terraform fmt && terraform validate -json | ConvertFrom-Json).valid
if ($valid) { terraform apply -auto-approve }