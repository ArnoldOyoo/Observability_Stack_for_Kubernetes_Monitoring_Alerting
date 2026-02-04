# Terraform EKS Cluster

This Terraform config provisions an AWS VPC and EKS cluster suitable for the observability stack.

## Quick start

```bash
terraform init
terraform apply -var-file=terraform.tfvars
```

## Outputs

- `cluster_name`
- `cluster_endpoint`
- `cluster_security_group_id`
- `kubeconfig_command`
