# rh-ex407

Repository for CI, IaC, and Ansible code, and notes for the RHCS Ansible EX407 Exam




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
|      | prod  | dev , test |


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
- [ ] Create a 


## Ansible galaxy

Configure and use ansible-galaxy to use a requirements file to download roles.

- [ ] Create a requirements file in `/home/carlton/ansible/requirements.yaml`
- [ ] Use Ansible galaxy to install the role in the requirements file to the `/home/carlton/ansible/roles` directory

## rhel-system-roles

Using the provided rhel-system-roles create a playbook named `/home/carlton/ansible/system-roles.yml` that will perform the following actions on `all` hosts:

- [ ] Use the provided selinux role to set your system to `enforcing` and `targeted.
- [ ] Set the time server as follows to `pool.ntp.org`. Keep all other settings as defaults.
