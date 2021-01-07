In this step, we setup the VPC, and the DB / WAF / R53 to be used for later steps.

Before we starts, review `main.tf`, and create `terraform.tfvars` based on `terraform.tfvars.example`, and replace values to your own.

## Infra
```
cd terraform
terraform init
terraform apply -target=module.network
terraform apply -target=module.r53
terraform apply -target=module.wordpress-db
terraform apply -target=module.waf
```
