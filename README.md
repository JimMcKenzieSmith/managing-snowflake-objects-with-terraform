# Managing Snowflake Objects With Terraform

This is a proof of concept and demo project that shows how to manage Snowflake objects using Terraform.

## Prerequisites
1. ACCOUNTADMIN role access to a Snowflake account, or get a free trial (https://www.snowflake.com/trial_faqs/).
2. Install SnowSQL (https://docs.snowflake.com/en/user-guide/snowsql-config.html)
3. Configure SnowSQL (https://docs.snowflake.com/en/user-guide/snowsql-config.html)
4. Install the latest version of Terraform (https://learn.hashicorp.com/tutorials/terraform/install-cli)
5. Access to an AWS account for S3 bucket creation and SNS topic creation.

## Setup

### Create a Service User for Terraform

We will now create a user account separate from your own that uses key-pair authentication. The reason this is required is due to the provider's limitations around caching credentials and the lack of support for 2FA. Service accounts and key pair are also how most CI/CD pipelines run Terraform.

**Create an RSA key for Authentication**

This creates the private and public keys we use to authenticate the service account we will use for Terraform.
```
$ cd ~/.ssh
$ openssl genrsa -out snowflake_tf_snow_key 4096
$ openssl rsa -in snowflake_tf_snow_key -pubout -out snowflake_tf_snow_key.pub
```
**Create the User in Snowflake**

Log in to the Snowflake console using `snowsql` and create the user account by running the following command as the ACCOUNTADMIN role.

But first:

1. Copy the text contents of the ~/.ssh/snowflake_tf_snow_key.pub file, starting after the PUBLIC KEY header, and stopping just before the PUBLIC KEY footer.
2. Paste over the RSA_PUBLIC_KEY_HERE label (shown below).

Execute the following SQL statements to create the User and grant it access to the SYSADMIN and SECURITYADMIN roles needed for account management.
```
USE ROLE ACCOUNTADMIN;

CREATE USER "tf-snow" RSA_PUBLIC_KEY='RSA_PUBLIC_KEY_HERE' DEFAULT_ROLE=PUBLIC MUST_CHANGE_PASSWORD=FALSE;

GRANT ROLE SYSADMIN TO USER "tf-snow";
GRANT ROLE SECURITYADMIN TO USER "tf-snow";
```
**NOTE:** We grant the user SYSADMIN and SECURITYADMIN privileges here to keep things simple. An important security best practice, however, is to limit all user accounts to least-privilege access. In a production environment, this key should also be secured with a secrets management solution like AWS Secrets Manager.

### Setup Terraform Authentication

We need to pass provider information via environment variables and input variables so that Terraform can authenticate as the user.

Run the following in `snowsql` to find the `YOUR_SNOWFLAKE_ACCOUNT_HERE` value needed as an export environment variable:
```
SELECT current_account();
```
**Add Account Information to Environment**

Add these export commands in your your .bash_profile or .zshrc file. Be sure to replace the `YOUR_*_HERE` placeholders with the correct values and set your region to correspond with how the Snowflake account is set up.
```
export SNOWFLAKE_USER="tf-snow"
export SNOWFLAKE_PRIVATE_KEY_PATH="~/.ssh/snowflake_tf_snow_key"
export SNOWFLAKE_ACCOUNT="YOUR_SNOWFLAKE_ACCOUNT_HERE"
export SNOWFLAKE_REGION="us-west-2"
export TF_VAR_aws_key_id="YOUR_AWS_KEY_ID_HERE"
export TF_VAR_aws_secret_key="YOUR_AWS_SECRET_KEY_HERE"
```
Run `source ~/.bash_profile` or `source ~/.zhsrc` to pick up the values in your current shell, or open a new shell.

The sns arn is used by the snowflake pipe for notifications to auto ingest new data.

### Setup AWS - SNS and S3

The terraform will automatically create and configure the S3 bucket and SNS topic.  The SNS topic will notify Snowflake that there is a file in S3 to auto ingest. In the S3 bucket properties, an event notification is set up to point to the SNS topic. An access policy is added to allow Snowflake to subscribe to the SNS.

## Initialize the Project

To set up the project to run Terraform, you first need to initialize the project.

Run the following from a shell in your project folder:
```
$ cd infrastructure/
$ terraform init
```
The dependencies needed to run Terraform are downloaded to your local environment. Note that gitignore is set up to ignore these downloaded dependencies.

## Running Terraform

From a shell in your project folder (with your Account Information in environment), run:
```
$ terraform plan
```
Now that you have reviewed the plan, we simulate the next step of the CI/CD job by applying those changes to your account.

1. From a shell in your project folder (with your Account Information in environment) run:
```
$ terraform apply
```
2. Terraform recreates the plan and applies the needed changes after you verify it. In this case, Terraform will be creating two new resources, and have no other changes.
3. Log in to your Snowflake account and verify that Terraform created the database and the warehouse.

## Notes on Resources Created

All databases need a schema to store tables, so we added that and a service user so that our application/client can connect to the database and schema. We also added privileges so the service role/user can use the database and schema.

## Cleanup

### Destroy all the Terraform Managed Resources
1. From a shell in your project folder (with your Account Information in environment) run:
```
$ terraform destroy
```
2. Accept the changes if they look appropriate.
3. Log in to the console to verify that all the objects are destroyed. The database, schema, warehouse, role, and the user objects created by Terraform will be automatically deleted.
### Drop the User we added
From your `snowsql` console run:
```
   DROP USER "tf-snow";
```
