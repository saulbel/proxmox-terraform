#!/bin/bash

# install wget and unzip
sudo apt update
sudo apt install unzip wget -y

# download packer
wget https://releases.hashicorp.com/terraform/1.3.5/terraform_1.3.5_linux_amd64.zip

# unzip it
unzip terraform_1.3.5_linux_amd64.zip

# move it to /usr/local/bin
sudo mv terraform /usr/local/bin

# remove zip
rm terraform_1.3.5_linux_amd64.zip