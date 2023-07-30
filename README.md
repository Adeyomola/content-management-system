## ANSIBLE VARIABLES

Create the following variables in a file called secrets.yml

- db_user
- db_password
- dp_port
- email
- email_password
- mail_server
- slack_api

Then encrypt the secrets.yml file with ansible vault.

## CREATING THE S3 AND DYNAMO DB BACKEND FOR TERRAFORM

- Once the variables and sensitive information are in place, `cd` into the backend directory and adjust the `variables.tf`.
- Open the `s3.tf` file and comment out `force_destroy = true` in the `aws_s3_bucket` resource block.
- Then run `terraform init && terraform apply -auto-approve`

## CREATING THE JENKINS SERVER

- After creating Terraform backend, `cd` into the jenkins directory and adjust the `variables.tf`.
- Then run `terraform init && terraform apply -auto-approve`

## PROVISION AND DEPLOY

### JENKINS CREDENTIALS

- Create a password file; add your ansible vault password to that file.
- Then upload the file to a secret file credential with ID: `ANSIBLE_VAULT_PASSWORD_FILE`.
- Create four secret texts with IDs: 
* AWS_ACCESS_KEY_ID
* AWS_SECRET_ACCESS_KEY
* TF_VAR_account_id=[AWS Account ID]
* TF_VAR_db_user=[Database Username in Base64]
* TF_VAR_db_password=[Database Password in Base64]
* TF_VAR_db_port=[Database Port Number]
* TF_VAR_db_name=[Database Name]
* TF_VAR_arn=[AWS ARN]
* TF_VAR_email=[email address for SSL certificate]
- Then Build
