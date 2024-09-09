#!/bin/bash

#echo "ansible-playbook -i hosts main.yml --extra-var version="8" --extra-var='{"target_hosts": [nested8-myjobname1-host.vpshere.local,nested8-myjobname2-host.vpshere.local]}' --extra-var='{"target_vcs": [nested8-myjobname-VC.vpshere.local]}' --extra-var removevsphere=true -t removevsphere"

echo "@@@"
#time ansible-playbook -i hosts main.yml --extra-var version="8" --extra-var='{"target_hosts": [nested8-myjobname1-host.vpshere.local,nested8-myjobname2-host.vpshere.local]}' --extra-var='{"target_vcs": [nested8-myjobname-VC.vpshere.local]}' --extra-var removevsphere=true -t removevsphere

echo "@@@ GOING TO CREATE NESTED VSPHERE ENVIRONMENT"
#echo 'ansible-playbook -i hosts main.yml --extra-var version="8" --extra-var='{"target_hosts": [nested8-myjobname1-host.vpshere.local,nested8-myjobname2-host.vpshere.local]}' --extra-var='{"target_vcs": [nested8-myjobname-VC.vpshere.local]}' --extra-var esximemory="65536" --extra-var esxicpu="16" '

echo "@@@"
time ansible-playbook -i hosts main.yml --extra-var version="8" --extra-var='{"target_hosts": [nested8-singlemyjobname1-host.vpshere.local]}' --extra-var='{"target_vcs": [nested8-singlemyjobname-VC.vpshere.local]}' --extra-var esximemory="65536" --extra-var esxicpu="16"

echo "@@@ DONE"
