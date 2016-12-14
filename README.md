# parsec-terraform
A simple Terraform template and automation tool to build a Parsec Server inside a VPC in AWS.

This uses a modified Parsec AMI with Steam pre-installed for quick setup. Default password: @w3some.

Only tested on OSX.

## How to use this
1. Clone this repo.
2. [Install Terraform.](https://www.terraform.io/intro/getting-started/install.html)
3. Ensure you have [aws](https://docs.aws.amazon.com/cli/latest/userguide/installing.html) and [jq](https://stedolan.github.io/jq/download/) installed.
6. Run `./bin/parsecadm plan <aws region> <parsec authcode>` from the root of the repo to see the plan of resources that will be provisioned.
7. Run `./bin/parsecadm apply <aws region> <parsec authcode>` from the room of the repo to build your Parsec server.
8. Run `./bin/parsecadm destroy` to remove all resources`.
