# Installing Kubernetes on AWS

Mainly using this course to build a base K8s environment for all other labs or testing I want to spin up.

There are 2 main steps to the process here:
1. Create the AWS infra using Terraform
2. Create the k8s cluster (or install) using Ansible

# Terraform Startup

## Items to update before running Terraform
1. Set env vars


## Env Vars

The AWS key variables should be env vars and not in the tf files. Set the env vars by:

```
export TF_VAR_aws_access_key="YOUR_ACCESS_KEY"
export TF_VAR_aws_secret_key="YOUR SECRET KEY"
```

These env vars really relate to the AWS CLI, but terraform picks them up. So the env vars reference is [here](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html).
```
export AWS_ACCESS_KEY_ID="YOUR_ACCESS_KEY"
export AWS_SECRET_ACCESS_KEY="YOUR SECRET KEY"
```

## SSH to instances
if using ACG playgroud, the username is `cloud_user` or whatever the username is to log into the sandbox's console.

Example:
```
% ssh -i id_rsa ubuntu@3.88.16.48
```
If you put the env vars in after running terraform you can do
```
ssh -i ~/.ssh/id_rsa ubuntu@$control1
``` 

# Ansible Startup

## Items to update once Terraform is done
1. Put appropriate IPs in 'hosts' file

## Ansilble commands to run in order

I know I'm doing this poorly and shouldn't have to run these commands like this. Will hopefully get a good playbook going.

First test connectivity with

`ansible -i hosts all -m ping`

```
ansible-playbook -i hosts playbooks/kubernetes/main_playbook.yml
```

# Notes
Sites I used. Mainly the webpages I thought I might not find again.

[How To Install A Private Docker Container Registry In Kubernetes](https://www.paulsblog.dev/how-to-install-a-private-docker-container-registry-in-kubernetes/)

[Deploy a Kubernetes Cluster using Ansible - buildVirtual](https://buildvirtual.net/deploy-a-kubernetes-cluster-using-ansible/)

[Building Kubernetes cluster on AWS cloud using Terraform and Ansible | SloopStash Blog](https://sloopstash.com/blog/building-kubernetes-cluster-on-aws-cloud-using-terraform-and-ansible.html)

[Sample Ansible setup — Ansible Documentation](https://docs.ansible.com/ansible/latest/tips_tricks/sample_setup.html)
