# rh-ex407

Repository for CI, IaC, and Ansible code, and notes for the RHCS Ansible EX407 Exam

## Contents

* .circleci
  * CirecleCI for automating this project.  
  * Requires some CircleCI environment variable to be setup that need to be documented if you want to use :o
* ansible
  * Just some sample code that I was messing around with for practicing.
* docker
  * WAS going to be a simple ansible docker image. Didn't need it YET.
* lambda
  * Not used yet
* terraform
  * Deploys the test environment
* README.md
  * This file!  Contains terrible setup instructions and even worse sample exam.


## Requirements

* Administrative access to an AWS account's EC and VPC services.
* Availability to create a new VPC
* Availability to create a new Elastic IP Address
* An existing AWS SSH Keypair

## Setup

This project sets up a small test environment using Hashicorp's Terraform and AWS as the Cloud Provider.


* Checkout this repo on a server with that is configured to administer your AWS environment either via access keys or instance roles
* Configure the following variable in the `terraform/variables.tf` file to meet your AWS account:
  * Set the variable ssh_key to the contents of RSA version of your AWS SSH Key.
    * Specifically everything between the following lines NOT including those lines:
    ```
    -----BEGIN RSA PRIVATE KEY-----
    -----END RSA PRIVATE KEY-----
    ```
    * Note: This is sa security risk if you are not maintaining this as a secret.  I am using CircleCi environment variables to encrypt this.  Use at your own risk.
      * You can alternatively not set this variable and manually set the contents of the `/home/carlton/.ssh/id_rsa` file to the contents of your AWS SSH Private key.
  * key_name
    * Set this variable to the name of the AWS SSH Keypair you wish to use to connect to your hosts.
      * The public key will be applied to the user `carlton` that is to be used in the sample exam.
  *
* Install Terraform cli
  * `steps required`
* Intialize the project
  * `cd terrarform; terraform init`
* Deploy the project


## EX407 Practice
---

### System Configuration

The ec2 instance with the name tag of `devops-jump-host` will be used as the control node for deployment.

The user and it's home directory will be used to run any ansible commands.
  * carlton

User carlton status:
 * ssh keys configured to allow management of all nodes
 * Sudoers configured to allow passwordless sudo for all commands on all knows.

---

## Setup the jump host

### Basic configuration
- [ ] Validate ansible is installed at version 2.7
- [ ] Create directory the following directories `/home/carlton/ansible`

### Configure inventory
- [ ] Create an inventory file with the following group configurations in `/home/carlton/ansible/inventory`

|host |group | child groups|
|---|---|---|
|node1 | dev | |
|node2 | proxy| |
|node3 | web| |
|node4 | web| |
|      | prod  | proxy , web |


### Ansible configuration
Configure the ansible configuration as follows.

- [ ] Create ansible configuration in `/home/carlton/ansible/ansible.cfg`.
- [ ] Add `/home/carlton/ansible/roles` to the roles path.
- [ ] Set inventory following inventory in `/home/carlton/ansible/inventory.`
- [ ] Set max forks to 10.

## Adhoc commands

Create a bash script in /home/carlton/ansible/adhoc.sh that does the following to `all` hosts:

- [ ] Put the following contents in /etc/motd
```
I am an awesome ansible managed node!
```
- [ ] Create a yum repository file with the following
  - [ ] Name: rpmforge
  - [ ] Description: RPMForge Yum repo
  - [ ] URL: http://apt.sw.be/redhat/el7/en/$basearch/rpmforge
  - [ ] GPG Check disabled
  - [ ] Repository enabled

## LVM Configuration

Create a playbook file `/home/carlton/ansible/adhoc.` that runs against `all` nodes with the following logical volume configuration:

- [ ] Create a volume group named vgextra
  - [ ] Physical volume for volume group should be /dev/sdh
  - [ ] If /dev/sdh does not exist then display error `"No /dev/sdh available to create pv."` and continue playbook
- [ ] Create a logical volume named lvextra in the volume group vgextra with a size of 5Gib.
  - [ ] If the volume group does not exist then display error `"No VG vgextra available to create lv."` and continue playbook.
  - [ ] If the there is not enough space available in the volume group then display the error `"Space not available in VG vgextra to create lv."`
- [ ] Create an ext4 filesystem on any logical volume you were able to create.
- [ ] Mount the new filesystem on /mnt/extra and make sure it persists reboot IF possible.

## rhel-system-roles

Using the provided rhel-system-roles create a playbook named `/home/carlton/ansible/system-roles.yml` that will perform the following actions on `all` hosts:

- [ ] Use the provided selinux role to set your system to `enforcing` and `targeted`.
- [ ] Set the time server as follows to `pool.ntp.org`. Keep all other settings as defaults.
- [ ] Run the play book against all inventory controlled nodes.


## Create role and playbook to install httpd

Create a role that sets up the httpd service the on the server in the `web` group.

- [ ] Create a role named webserver
- [ ] Install the `httpd` service and configure it be available on reboot.
- [ ] Create an file `/var/www/html/index.html` that replaces the <fqdn> with the fully qualified domain name and the <ip> with IP address of the node as follows:
    `Hello!  I am <fqdn> with an <ip> of <IP Address?`
- [ ] Install and enable the firewalld service.
- [ ] Enable the httpd port in the node's local firewall.
- [ ] Make a directory and file /mypage/index.html with the following contents:
   `I am your page!`
- [ ] Create a symlink to /mypage/ from /var/www/html/mypage
- [ ] Ensure when you browse to any of the nodes in the webserver at `http://<webserver node>/mypage/` you get the text `I am your page!` and not anything else.
- [ ] Create and copy a file to `/mypage/system-report` with the following contents:
```
HOSTNAME: ???
MEMORY MB: ???
XVDA GB: ???
XVDA GB: ???
```


## Ansible galaxy

Configure and use ansible-galaxy to use a requirements file to download roles.

- [ ] Create a requirements file in `/home/carlton/ansible/requirements.yml`
- [ ] Use Ansible galaxy to install the role `geerlingguy.haproxy` in the requirements file to the `/home/carlton/ansible/roles` directory named `haproxy`
- [ ] Create an and run the playbook `/home/carlton/ansible/haproxy.yml` that deploys the `haproxy` role downloaded from the requirements files.
  - [ ] Playbook should target nodes in the `proxy` group.
  - [ ] Configure the backend servers to be the IP addresses of the servers in the web directory on port 80.


## Vault Vault  Vault - always vault

You will need to understand how to use ansible-vault to encrypt variables.

- [ ] Create a vault encrypted file `/home/carlton/ansible/secrets.yml`, with a password file of `/home/carlton/ansible/password.txt`.
  - [ ] Password file password: IamthepasswordYAY!!!
  - [ ] The secrets.yml file must have the following variable:
     `user_password: IamtheuserpasswordWEEEEE!`

## Users

Create users and user vault files in a playbook.

- [ ] Create a variables file `/home/carlton/ansible/user_vars.yml` that contains the following
```
---
users:
  - username: bison
    division: ops
    role: manager
  - username: cammy
    division: ops
    role: developer
  - username: ryu
    division: qa
    role: qa
```
- [ ] Create playbook `/home/carlton/ansible/users.yml` that uses the variables from the encrypted `/home/carlton/ansible/secrets.yml` file to configure passwords.
- [ ] Playbook should be run against all hosts.
- [ ] Assign all users with password stored in the user_password variable, SHA-512 encryoted, from the vault encrypted `/home/carlton/ansible/secrets.yml` file.
- [ ] Create users with a role of `manager` on `all` hosts.
- [ ] Create users with a division of `ops` on nodes in the `prod` group.
- [ ] Create users with a division of `qa` on nodes in the `dev` group and assign them the additional group `devtest`.
- [ ] Run the playbook `/home/carlton/ansible/users.yml`

## System Report

Download and configure a file using facts.

- [ ] Create the playbook `/home/carlton/ansible/report.yml`
- [ ] Playbook must download the file `http://node3/mypage/system-report` and copy it to each node
- [ ] Each node must replace the values in `???` in the file as follows:

```
HOSTNAME: The hostname of the node
MEMORY MB: Memory in MB
XVDA GB: Size of device /dev/xvda in GB
XVDH GB: Size of device /dev/xvda in GB
```
- [ ] If a device or setting doesn't exist replace the `???` with the word `NONE`
