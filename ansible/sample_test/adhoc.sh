#!/bin/bash
ansible -m "copy" -a "src=files/motd dest=/etc/motd" -b all
ansible -m "copy" -a "src=files/rpmforge.repo dest=/etc/yum.repos.d" -b all
