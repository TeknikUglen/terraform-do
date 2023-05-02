# Terraform

## sources

- https://www.howtogeek.com/devops/how-to-create-a-digitalocean-droplet-using-terraform/
- https://developer.hashicorp.com/terraform/downloads
- https://developer.hashicorp.com/terraform/tutorials/aws-get-started/aws-build
- https://developer.hashicorp.com/terraform/language/values/variables

## Getting started

> Terraform can be installed via pacman in Arch Linux.

To get started create the configuration files `terraform.tfvars`, `variables.tf` and `digitalocean.tf`.  
Populate with values as necessary.

Any file with the extension `.tf` will be automatically loaded. For the extension `tfvars` only the file `terraform.tfvars` will be automatically loaded. 

- `terraform.tfvars`  
  contains the variable values and is automatically loaded.

  ```
  do_api_token = "1234567890123456789"
  do_vpc_uuid="12345678-abcd-1234-4567-12345678"
  do_ssh_keys=["00:00:00:00:00:00:00:00:00:00:00:00:00"]
  ```

- `variables.tf`  
  contains the variable type and setup and is automatically loaded.

  ```
  variable "do_api_token" {
    description = "API token for Digital Ocean"
    type        = string
    default     = ""
  }

  variable "do_vpc_uuid" {
    description = "VPC UUID for Digital Ocean"
    type        = string
    default     = ""
  }

  variable "do_ssh_keys" {
    description = "SSH Key array"
    type        = list(string)
    default     = [""]
  }
  ```

- `digitalocean.tf`  
  contains the actual definition of servers to create

  ```
  terraform {
    required_providers {
      digitalocean = {
        source = "digitalocean/digitalocean"
        version = "2.28.0"
      }
    }
  }

  provider "digitalocean" {
    token = var.do_api_token
  }

  resource "digitalocean_droplet" "web" {
    image = "debian-11-x64"
    name = "test-web-vm"
    region = "ams3"
    size = "s-1vcpu-512mb-10gb"
    monitoring = true
    backups = false
    ipv6 = false
    ssh_keys           = var.do_ssh_keys
    vpc_uuid           = var.do_vpc_uuid
  }
  ```

## Initialize terraform for the current folder

```
terraform init
```

## apply the terraform configuration

```
terraform apply
```

output:

```
Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:

- create

Terraform will perform the following actions:

# digitalocean_droplet.web will be created

- resource "digitalocean_droplet" "web" {
  - backups = false
  - created_at = (known after apply)
  - disk = (known after apply)
  - graceful_shutdown = false
  - id = (known after apply)
  - image = "debian-11-x64"
  - ipv4_address = (known after apply)
  - ipv4_address_private = (known after apply)
  - ipv6 = false
  - ipv6_address = (known after apply)
  - locked = (known after apply)
  - memory = (known after apply)
  - monitoring = true
  - name = "test-web-vm"
  - price_hourly = (known after apply)
  - price_monthly = (known after apply)
  - private_networking = (known after apply)
  - region = "ams3"
  - resize_disk = true
  - size = "s-1vcpu-512mb-10gb"
  - status = (known after apply)
  - urn = (known after apply)
  - vcpus = (known after apply)
  - volume_ids = (known after apply)
  - vpc_uuid = "12345678901234567890"
    }

Plan: 1 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
Terraform will perform the actions described above.
Only 'yes' will be accepted to approve.

Enter a value: yes

digitalocean_droplet.web: Creating...
digitalocean_droplet.web: Still creating... [10s elapsed]
digitalocean_droplet.web: Still creating... [20s elapsed]
digitalocean_droplet.web: Still creating... [30s elapsed]
digitalocean_droplet.web: Still creating... [40s elapsed]
digitalocean_droplet.web: Creation complete after 41s [id=352367804]

Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
```

## show details for current applied configuration

```
terraform show
```

output:

```
# digitalocean_droplet.web:

resource "digitalocean_droplet" "web" {
backups = false
created_at = "2023-04-25T17:36:09Z"
disk = 10
graceful_shutdown = false
id = "123456789"
image = "debian-11-x64"
ipv4_address = "188.166.11.144"
ipv4_address_private = "10.133.0.5"
ipv6 = false
locked = false
memory = 512
monitoring = true
name = "test-web-vm"
price_hourly = 0.00595
price_monthly = 4
private_networking = true
region = "ams3"
resize_disk = true
size = "s-1vcpu-512mb-10gb"
status = "active"
urn = "do:droplet:1234567890"
vcpus = 1
volume_ids = []
vpc_uuid = "12345678901234567890"
}
```

## Change

Changing the digital ocean container we created can be done by editing the terraform configuration file and running the apply command again.

One such change could be to define output data (values) that can be used for external programs.

create a file `outputs.tf` and populate it as follows:

```
output "instance_id" {
description = "ID of the DO droplet"
value = digitalocean_droplet.web.id
}

output "instance_public_ip" {
description = "Public IP address of the DO droplet"
value = digitalocean_droplet.web.ipv4_address
}
```

This will cause the values to be available using the following command. Both in raw and formatted format.

```
terraform output -raw instance_public_ip
188.166.11.144%

terraform output instance_public_ip
"188.166.11.144"
```

## remove the terraform configured droplet

```
terraform destroy
```

add `-auto-approve` to skip interactive prompt.

[![License: ISC](https://img.shields.io/badge/License-ISC-blue.svg)](https://opensource.org/licenses/ISC)