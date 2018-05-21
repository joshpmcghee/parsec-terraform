# parsec-terraform
A simple Terraform template and automation tool to build a Parsec Server inside a VPC in AWS in the least expensive availability zone.

This uses a modified Parsec AMI with Steam pre-installed for quick setup. Default password: @w3some.

Only tested on OSX.

## How to use this
1. Clone this repo.
2. [Install Terraform.](https://www.terraform.io/intro/getting-started/install.html)
3. Ensure you have [aws](https://docs.aws.amazon.com/cli/latest/userguide/installing.html) and [jq](https://stedolan.github.io/jq/download/) installed.
4. Create a `terraform.tfvars` in your current directory, and set it up using the template listed below.
5. Run `./bin/parsecadm plan <aws region> <parsec authcode>` from the root of the repo to see the plan of resources that will be provisioned.
6. Run `./bin/parsecadm apply <aws region> <parsec authcode>` from the room of the repo to build your Parsec server.
7. Run `./bin/parsecadm destroy` to remove all resources.


## terraform.tfvars

By default, [terraform will use variables stored in the current directory's terraform.tfvars file](https://www.terraform.io/intro/getting-started/variables.html). You can set these up to match your needs.

```
parsec_authcode = "YOUR_PARSEC_AUTHCODE"
aws_access_key = "YOUR_AWS_ACCESS_KEY_ID"
aws_secret = "YOUR_AWS_SECRET_ACCESS_KEY"
aws_region = "YOUR_AWS_REGION"
aws_vpc = "YOUR_AWS_VPC"
aws_subnet = "YOUR_AWS_SUBNET"
aws_spot_price = "0.7" # This is the price per compute hour you are willing to pay.
```
