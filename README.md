# terraform-aws-module-template

## Overview

SourceFuse AWS Reference Architecture (ARC) Terraform module for managing _________.

## Usage

To see a full example, check out the [main.tf](./example/main.tf) file in the example folder.  

```hcl
module "this" {
  source = "git::https://github.com/sourcefuse/terraform-aws-refarch-<module_name>"
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.49.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_backup_vault"></a> [backup\_vault](#module\_backup\_vault) | ./modules/backup-vault | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_backup_plan.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_plan) | resource |
| [aws_backup_selection.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_selection) | resource |
| [aws_backup_vault_lock_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_vault_lock_configuration) | resource |
| [aws_iam_role.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.aws_backup_policy_backup_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.aws_backup_policy_restore_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_role) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_backup_plan"></a> [backup\_plan](#input\_backup\_plan) | Rules for AWS backup plan, null act as flag to enable or disable backup plan | <pre>object({<br>    name = string<br>    rules = list(object({<br>      name                     = string<br>      target_vault_name        = string<br>      schedule                 = string<br>      start_window             = optional(string, null)<br>      completion_window        = optional(string, null)<br>      recovery_point_tags      = optional(map(string), {})<br>      enable_continuous_backup = optional(bool, false)<br>      lifecycle = list(object({<br>        cold_storage_after = optional(number, 0)<br>        delete_after       = number<br>      }))<br><br>      copy_action = optional(list(object({<br>        destination_vault_arn = string<br>        lifecycle = optional(list(object({<br>          cold_storage_after = string<br>          delete_after       = string<br>        })), [])<br>      })), [])<br><br>    }))<br>  })</pre> | `null` | no |
| <a name="input_backup_selection_data"></a> [backup\_selection\_data](#input\_backup\_selection\_data) | (optional) Backup selection criteria to select resources | <pre>object({<br>    name      = string<br>    plan_name = string<br>    resources = optional(list(string), ["*"]) // List of resources eg [ "arn:aws:ec2:*:*:instance/*" ] , * -> All supported resources<br>    selection_tags = optional(list(object({<br>      type  = string<br>      key   = string<br>      value = string<br>    })), [])<br>  })</pre> | `null` | no |
| <a name="input_backup_vault_data"></a> [backup\_vault\_data](#input\_backup\_vault\_data) | Details to create backup vault, null act as flag to enable or disable | <pre>object({<br>    name                            = string<br>    backup_role_name                = string<br>    enable_encryption               = optional(bool, true)<br>    kms_key_deletion_window_in_days = optional(number, 7)<br>    kms_key_admin_arns              = optional(list(string), [])<br>  })</pre> | `null` | no |
| <a name="input_create_role"></a> [create\_role](#input\_create\_role) | (optional) Role Required for taking backup and restore | `bool` | `true` | no |
| <a name="input_role_name"></a> [role\_name](#input\_role\_name) | IAM role name | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags for AWS backup service | `map(string)` | n/a | yes |
| <a name="input_vault_lock_configuration"></a> [vault\_lock\_configuration](#input\_vault\_lock\_configuration) | (optional) Vault lock configuration , changeable\_for\_days > 0 , then its `governance` else `compliance` mode | <pre>object({<br>    changeable_for_days = number<br>    max_retention_days  = number<br>    min_retention_days  = number<br>  })</pre> | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_backup_plan_id"></a> [backup\_plan\_id](#output\_backup\_plan\_id) | AWS backups plan ID |
| <a name="output_backup_role_arn"></a> [backup\_role\_arn](#output\_backup\_role\_arn) | IAM Role for taking backups |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Versioning  
This project uses a `.version` file at the root of the repo which the pipeline reads from and does a git tag.  

When you intend to commit to `main`, you will need to increment this version. Once the project is merged,
the pipeline will kick off and tag the latest git commit.  

## Development

### Prerequisites

- [terraform](https://learn.hashicorp.com/terraform/getting-started/install#installing-terraform)
- [terraform-docs](https://github.com/segmentio/terraform-docs)
- [pre-commit](https://pre-commit.com/#install)
- [golang](https://golang.org/doc/install#install)
- [golint](https://github.com/golang/lint#installation)

### Configurations

- Configure pre-commit hooks
  ```sh
  pre-commit install
  ```

### Versioning

while Contributing or doing git commit please specify the breaking change in your commit message whether its major,minor or patch

For Example

```sh
git commit -m "your commit message #major"
```
By specifying this , it will bump the version and if you don't specify this in your commit message then by default it will consider patch and will bump that accordingly

### Tests
- Tests are available in `test` directory
- Configure the dependencies
  ```sh
  cd test/
  go mod init github.com/sourcefuse/terraform-aws-refarch-<module_name>
  go get github.com/gruntwork-io/terratest/modules/terraform
  ```
- Now execute the test  
  ```sh
  go test -timeout  30m
  ```

## Authors

This project is authored by:
- SourceFuse ARC Team
