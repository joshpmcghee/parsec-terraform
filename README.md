# parsec-terraform
A simple Terraform template to build a Parsec Server inside a VPC in AWS.

Only tested on OSX.

## How to use this
1. Clone this repo.
2. [Install Terraform.](https://www.terraform.io/intro/getting-started/install.html)
3. Create a `~/.tfvars` file that looks like the template below with your vars substituted.
4. Run `terraform plan -var-file=~/.tfvars` in the root of the repo to check that Terraform can and will build what you want it to.
5. Run `terraform apply -var-file=~/.tfvars` to build your server.

## .tfvars
```
parsec_authcode = "YOUR_PARSEC_AUTHCODE"
aws_access_key = "YOUR_AWS_ACCESS_KEY_ID"
aws_secret = "YOUR_AWS_SECRET_ACCESS_KEY"
aws_region = "YOUR_AWS_REGION"
aws_vpc = "YOUR_AWS_VPC"
aws_subnet = "YOUR_AWS_SUBNET"
```
