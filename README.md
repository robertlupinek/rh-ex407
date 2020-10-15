# rh-ex407

Repository for CI, IaC, and Ansible code, and notes for the RHCS Ansible EX407 Exam




## EX407 Practice



---

### System Configuration :

The ec2 instance with the name tag of `devops-jump-host` will be used as the control node for deployment.

The user and it's home directory will be used to run any ansible commands.
  * carlton

User carlton status:
 * ssh keys configured to allow management of all nodes
 * Sudoers configured to allow passwordless sudo for all commands on all knows.

---

## Setup the jump host:

### Basic configuration
[checkbox:unchecked] Validate ansible is installed at version 2.7
[checkbox:unchecked] Create directory the following directories `/home/carlton/ansible`

### Configure inventory
[checkbox:unchecked] Create an inventory file with the following group configurations in `/home/carlton/ansible/inventory`

|host |group | child groups|
|---|---|---|
|node1 | dev | |
|node2 | proxy| |
|node3 | web| |
|node4 | web| |
|      | prod  | dev , test |


### Ansible configuration
Configure the ansible configuration as follows.

[checkbox:unchecked] Create ansible configuration in `/home/carlton/ansible/ansible.cfg`.
[checkbox:unchecked] Add `/home/carlton/ansible/roles` to the roles path.
[checkbox:unchecked] Set inventory following inventory in `/home/carlton/ansible/inventory.`
[checkbox:unchecked] Set max forks to 10.

## Adhoc commands

Create a bash script in /home/carlton/ansible/adhoc.sh that does the following:

[checkbox:unchecked] Put the following contents in /etc/motd
```
I am an awesome ansible managed node!
```
[checkbox:unchecked] Create a yum repostory file with the following
  [checkbox:unchecked] Name: rpmforge
  [checkbox:unchecked] Description: RPMForge Yum repo
  [checkbox:unchecked] URL: http://apt.sw.be/redhat/el7/en/$basearch/rpmforge
  [checkbox:unchecked] GPG Check disabled
  [checkbox:unchecked] Repository enabled

## Ansible galaxy

Configure and use ansible-galaxy to use a requirements file to download roles.

[checkbox:unchecked] Create a requirements file in `/home/carlton/ansible/requirements.yaml`
[checkbox:unchecked] Use Ansible galaxy to install the role in the requirements file to the `/home/carlton/ansible/roles` directory

## rhel-system-roles

Using the provided rhel-system-roles a playbook named `/home/carlton/ansible/system-roles.yml` that will perform the following actions on `all` hosts:

[checkbox:unchecked] Use the provided selinux role to set your system to `enforcing` and `targeted.
[checkbox:unchecked] Set the time server as follows to `Need a time server...`. Keep all other settings as defaults.
