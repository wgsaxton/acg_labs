# Installing Kubernetes on AWS

Mainly using this course to build a base K8s environment for all other labs or testing I want to spin up.

There are 2 main steps to the process here:
1) Create the AWS infra using Terraform
2) Create the k8s cluster (or install) using Ansible

# Env Vars

The AWS key variables should be env vars and not in the tf files. Set the env vars by:

```
export TF_VAR_aws_access_key="YOUR_ACCESS_KEY"
export TF_VAR_aws_secret_key="YOUR SECRET KEY"
```

This is the AWS CLI way. Don't do it. example:

```
export AWS_ACCESS_KEY_ID=AKIAIOSFODNN7EXAMPLE
export AWS_SECRET_ACCESS_KEY=wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
```
These env vars really relate to the AWS CLI, but terraform picks them up. So the env vars reference is [here](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html).

# SSH to instances
if using ACG playgroud, the username is `cloud_user` or whatever the username is to log into the sandbox's console.

Example:
```
% ssh -i id_rsa cloud_user@3.88.16.48
```