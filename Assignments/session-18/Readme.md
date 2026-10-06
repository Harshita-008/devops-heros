# Session 18: Terraform and Infrastructure as Code

## 1. Infrastructure as Code

Infrastructure is written as code instead of being clicked together in the cloud console.

| Manual (console) | IaC (Terraform) |
|---|---|
| Repeated by hand | Same code, same result every time |
| No history | Reviewed and versioned in Git |
| Hard to copy to a new environment | Reused with different variables |

### AWS Setup

![alt text](./Screenshots/img_1.png)

### Init, Format, Validate, Plan

![alt text](./Screenshots/img_2.png)

### Apply and Verify

![alt text](./Screenshots/img_3.png)

### Destroy

![alt text](./Screenshots/img_4.png)

## 2. Terraform Architecture

```text
.tf files  ->  Terraform CLI  ->  AWS Provider  ->  AWS (S3, EC2, VPC)
                     |
              terraform.tfstate
```

Terraform is **declarative**: the code says what should exist, Terraform works out the API calls.

![alt text](./Screenshots/img_5.png)

![alt text](./Screenshots/img_6.png)

## 3. Providers

A provider is a plugin that lets Terraform talk to an API. `hashicorp/aws` with `~> 6.0` is
downloaded by `terraform init`. Credentials come from `aws configure`, never from the `.tf` files.

![alt text](./Screenshots/img_7.png)

![alt text](./Screenshots/img_8a.png)

![alt text](./Screenshots/img_8b.png)

## 4. Resources

```hcl
resource "aws_s3_bucket" "demo" { ... }
#        resource type   local name
```

The address `aws_s3_bucket.demo` is how Terraform tracks the resource in state.

### Create

![alt text](./Screenshots/img_9.png)

### Adding Tags (Update in Place)

![alt text](./Screenshots/img_10.png)

### Destroy

![alt text](./Screenshots/img_11.png)

## 5. Variables

Variables make the same code reusable for dev, test and prod. Values come from defaults,
`terraform.tfvars` or the command line. `terraform.tfvars` is kept out of Git.

### Plan with dev

![alt text](./Screenshots/img_12.png)

### Plan with test

![alt text](./Screenshots/img_13.png)

## 6. Outputs

Outputs print useful values after apply, such as IDs and ARNs, for people, other modules or CI/CD.

![alt text](./Screenshots/img_14.png)

![alt text](./Screenshots/img_15a.png)

![alt text](./Screenshots/img_15b.png)

## 7. Init, Plan and Apply

| Command | Purpose |
|---|---|
| `terraform init` | Download providers, set up the backend |
| `terraform fmt` | Format the code |
| `terraform validate` | Check the syntax |
| `terraform plan` | Preview: `+` create, `~` update, `-` destroy |
| `terraform apply` | Make the changes after typing `yes` |

### Init to Plan

![alt text](./Screenshots/img_16.png)

### Apply

![alt text](./Screenshots/img_17.png)

### Saved Plan

`plan -out=tfplan` saves the reviewed plan, and `apply tfplan` runs exactly that plan.

![alt text](./Screenshots/img_18.png)

## 8. Destroy

`terraform destroy` deletes **real** infrastructure. `terraform plan -destroy` previews it first.

![alt text](./Screenshots/img_19.png)

![alt text](./Screenshots/img_20.png)

## 9. State

`terraform.tfstate` maps each resource address to the real object in AWS. It can contain sensitive
values, so it is never committed and never edited by hand.

### Inspecting State

![alt text](./Screenshots/img_21.png)

### Full State

![alt text](./Screenshots/img_22.png)

### Destroy and Empty State

![alt text](./Screenshots/img_23.png)

## 10. Demo Project: S3 Bucket

A full project split into `terraform.tf`, `providers.tf`, `variables.tf`, `main.tf` and `outputs.tf`.

### Init to Plan

![alt text](./Screenshots/img_24a.png)

![alt text](./Screenshots/img_24b.png)

### Apply, Outputs and State

![alt text](./Screenshots/img_25a.png)

![alt text](./Screenshots/img_25b.png)

### Verify with AWS CLI

![alt text](./Screenshots/img_26.png)

### Destroy

![alt text](./Screenshots/img_27.png)

## Key Learnings

- **init → fmt → validate → plan → apply → destroy** is the Terraform lifecycle.
- `plan` always comes before `apply`, and `plan -destroy` before `destroy`.
- **State** is Terraform's memory of real infrastructure.
- Credentials, state and `.tfvars` files stay out of Git.
