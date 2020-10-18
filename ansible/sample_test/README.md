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
- [ ] Set inventory default inventory `/home/carlton/ansible/inventory.`
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
  - [ ] Mirrorlist: http://mirrorlist.repoforge.org/el7/mirrors-rpmforge
  - [ ] GPG Check disabled
  - [ ] Repository enabled

## Create a hosts files

Create a playbook `/home/carlton/ansible/hosts.yml` that runs against `all` nodes that performs the following:

- [ ] File `/home/carlton/hosts` must have the following contents generate from template named `/home/carlton/ansible/hosts.j2` where hosts order doesn't matter:

```
127.0.0.1               localhost.localdomain    localhost
::1                     localhost6.localdomain6    localhost6
10.0.0.80 node1
10.0.0.232 node2
10.0.0.233 node3
10.0.0.234 node4
```

## LVM Configuration

Create a playbook file `/home/carlton/ansible/lvm.yml` that runs against `all` nodes with the following logical volume configuration:

- [ ] Create a volume group named vgextra
  - [ ] Physical volume for volume group should be /dev/xvdh
  - [ ] If /dev/xvdh does not exist then display error `"No /dev/xvdh available to create pv."` and continue playbook
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

- [ ] Create a role named `webserver`.
- [ ] Install the `httpd` service and configure it be available on reboot.
- [ ] Create an file `/var/www/html/index.html` that replaces the <fqdn> with the fully qualified domain name and the <ip> with IP address of the node as follows:
    `Hello!  I am <fqdn> with an IP of <IP Address>.`
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
XVDH GB: ???
```
- [ ] Create a playbook `/home/carlton/ansible/webserver.yml` that runs the `webserver` role you just created against hosts in the `dev` and `web` groups.

## Ansible galaxy

Configure and use ansible-galaxy to use a requirements file to download roles.

- [ ] Create a requirements file in `/home/carlton/ansible/requirements.yml`
- [ ] Use Ansible galaxy to install the role `geerlingguy.haproxy` in the requirements file to the `/home/carlton/ansible/roles` directory named `haproxy`
- [ ] Create an and run the playbook `/home/carlton/ansible/haproxy.yml` that deploys the `haproxy` role downloaded from the requirements files.
  - [ ] Playbook should target nodes in the `proxy` group.
  - [ ] Configure the backend servers to be the IP addresses of the servers in the `web` group on port 80.


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
- [ ] Assign all users with password stored in the user_password variable, SHA-512 encrypted, from the vault encrypted `/home/carlton/ansible/secrets.yml` file.
- [ ] Create users with a role of `manager` on `all` hosts.
- [ ] Create users with a division of `ops` on nodes in the `prod` group.
- [ ] Create users with a division of `qa` on nodes in the `dev` group and assign them the additional group `devtest`.
- [ ] Run the playbook `/home/carlton/ansible/users.yml`

## System Report

Download and configure a file using facts.

- [ ] Create the playbook `/home/carlton/ansible/report.yml` targeting `all` nodes.
- [ ] Playbook must download the file `http://node3/mypage/system-report` and copy to `/home/carlton/report.txt` on each node.
- [ ] Each node must replace the values in `???` in the file as follows:

```
HOSTNAME: The hostname of the node
MEMORY MB: Memory in MB
XVDA GB: Size of device /dev/xvda in GB
XVDH GB: Size of device /dev/xvdh in GB
```
- [ ] If a device or setting doesn't exist replace the `???` with the word `NONE`
- [ ] Run the playbook `/home/carlton/ansible/report.yml`
