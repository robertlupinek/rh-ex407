# rh-ex407

Repository for CI, IaC, and Ansible code, and notes for the RHCS Ansible EX407 Exam

## Contents

* .circleci
  * CirecleCI for automating this project.  
  * Requires some CircleCI environment variable to be setup that need to be documented if you want to use :o
* ansible
  * Just some sample code that I was messing around with for practicing.  Nothing in there is anything close being best or even good practice.  Just practice. :)
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
