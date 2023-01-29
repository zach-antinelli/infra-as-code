$output = terraform fmt && terraform validate -json | ConvertFrom-Json
if ($output.valid) { terraform apply -auto-approve }