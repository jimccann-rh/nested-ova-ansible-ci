#!/bin/bash

echo "@@@ GOING TO CREATE NESTED VSPHERE ENVIRONMENT"
ansible-playbook -i hosts main.yml --extra-var version="7" --extra-var='{"target_hosts": [nested7-singlemyjobname1-host.vpshere.local]}' --extra-var='{"target_vcs": [nested7-singlemyjobname-VC.vpshere.local]}' --extra-var esximemory="65536" --extra-var esxicpu="16"


echo "@@@ DONE"
