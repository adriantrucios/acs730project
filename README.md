# acs730 Final Project group 10
Pre-requisites
- Install Terraform and updated to latest version
- Create the following S3 Bucket with below names from AWS console under S3
- group-10-acs-project
- Generate the SSH Key with below command "ssh-keygen -t rsa -f gopal" under below locations:-
- testing/acs730project/workspace/prod/webserver
- testing/acs730project/workspace/Dev/webserver
- testing/acs730project/workspace/staging/webserver

Deploy the prod environment 
- Go to testing/acs730project/workspace/prod/Network
- terraform init
- terraform validate
- terraform plan
- terraform apply

- Go to testing/acs730project/workspace/prod/webserver
- terraform init
- terraform validate
- terraform plan
- terraform apply

Deploy the Dev environment 

- Go to testing/acs730project/workspace/Dev/Network
- terraform init
- terraform validate
- terraform plan
- terraform apply

- Go to testing/acs730project/workspace/Dev/webserver
- terraform init
- terraform validate
- terraform plan
- terraform apply

Deploy the Staging environment

- Go to testing/acs730project/workspace/staging/Network
- terraform init
- terraform validate
- terraform plan
- terraform apply

- Go to testing/acs730project/workspace/staging/webserver
- terraform init
- terraform validate
- terraform plan
- terraform apply

After deployment, we can copy the dns and paste in web browser from the AWS console under Load Balancer console and it will resolves the different IP's.
