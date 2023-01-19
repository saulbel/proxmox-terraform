# proxmox-terraform

## Prerequisites
Things you need before starting:
* `Proxmox server`
* `Terraform`

## Project structure
```
proxmox-terraform
└── scripts
     └── setup.sh
└── terraform
    └── main.tf
    └── secrets.auto.tfvars
```
## Tasks to accomplish
- The idea of this project is to use `terraform` to deploy resources in `proxmox`.

## How to setup this project locally
- First we should download it with either `git clone` or as `.zip`.
- Then we will execute `setup.sh` in order to install `terraform 1.3.5`.
- Then you will have to modify `main.tf` and `secrets.auto.tfvars` with your `proxmox` data.

## How to run it
- Once you have everything ready, we just have to initialize `terraform`:
````
$ terraform init
Terraform has been successfully initialized!
````
- Then to check if our config is valid and what it will do:
````
$ terraform plan
````
- Finally we can apply those changes:
````
$ terraform apply
````
- To destroy our infra:
````
$ terraform destroy
````
- If we want to create or destroy a specific resource:
````
$ terraform apply -target=proxmox_lxc.debian_ct1
$ terraform destroy -target=proxmox_lxc.debian_ct1
````
## Infraestructure
  - Virtual Machine using `Packer` template
     + 2 cores
     + 2 Gb of memory
     + 20 Gb of storage
     + Static Ip
     + SSH key authentication
  - LXC 
     + 1 core
     + 1 Gb of memory
     + 10 Gb of storage
     + Static Ip
     + SSH key authentication

## Notes
- I will include more resources in `main.tf`.
- I will add `Ansible` to configure `vms` and `cts`.