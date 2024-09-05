#!/bin/bash
#ansible-playbook -i hosts main.yml --extra-var version="8" --extra-var='{"target_hosts": [nested8-myjobname-host.vpshere.local,nested8-myjobname-host1.vsphere.local]}'
#ansible-playbook -i hosts main.yml --extra-var version="8" --extra-var='{"target_hosts": [nested8-myjobname1-host.vpshere.local,nested8-myjobname2-host.vpshere.local]}' --extra-var='{"target_vcs": [nested8-myjobname-VC.vpshere.local]}' --extra-var testingesxi=true --extra-var testingvc=true
#ansible-playbook -i hosts main.yml --extra-var version="8" --extra-var='{"target_hosts": [nested8-myjobname1-host.vpshere.local,nested8-myjobname2-host.vpshere.local]}' --extra-var='{"target_vcs": [nested8-myjobname-VC.vpshere.local]}' --extra-var testingesxi=false --extra-var testingvc=false


echo "https://github.com/jimccann-rh/nested-ova-ansible"

echo "going to delete nested in 5 seconds"
sleep 10

echo "ansible-playbook -i hosts main.yml --extra-var version="8" --extra-var='{"target_hosts": [nested8-myjobname1-host.vpshere.local,nested8-myjobname2-host.vpshere.local]}' --extra-var='{"target_vcs": [nested8-myjobname-VC.vpshere.local]}' --extra-var removevsphere=true -t removevsphere"
echo 'ansible-playbook -i hosts main.yml --extra-var version="7" --extra-var='{"target_hosts": [nested7-myjobname1-host.vpshere.local,nested7-myjobname2-host.vpshere.local]}' --extra-var='{"target_vcs": [nested7-myjobname-VC.vpshere.local]}' --extra-var removevsphere=true -t removevsphere'

time ansible-playbook -i hosts main.yml --extra-var version="8" --extra-var='{"target_hosts": [nested8-myjobname1-host.vpshere.local,nested8-myjobname2-host.vpshere.local]}' --extra-var='{"target_vcs": [nested8-myjobname-VC.vpshere.local]}' --extra-var removevsphere=true -t removevsphere

time ansible-playbook -i hosts main.yml --extra-var version="7" --extra-var='{"target_hosts": [nested7-myjobname1-host.vpshere.local,nested7-myjobname2-host.vpshere.local]}' --extra-var='{"target_vcs": [nested7-myjobname-VC.vpshere.local]}' --extra-var removevsphere=true -t removevsphere

echo "going to create vsphere environments"
echo 'ansible-playbook -i hosts main.yml --extra-var version="8" --extra-var='{"target_hosts": [nested8-myjobname1-host.vpshere.local,nested8-myjobname2-host.vpshere.local]}' --extra-var='{"target_vcs": [nested8-myjobname-VC.vpshere.local]}' --extra-var esximemory="65536" --extra-var esxicpu="16" '
echo 'ansible-playbook -i hosts main.yml --extra-var version="7" --extra-var='{"target_hosts": [nested7-myjobname1-host.vpshere.local]}' --extra-var='{"target_vcs": [nested7-myjobname-VC.vpshere.local]}' --extra-var esximemory="65536" --extra-var esxicpu="16"'

time ansible-playbook -i hosts main.yml --extra-var version="8" --extra-var='{"target_hosts": [nested8-myjobname1-host.vpshere.local,nested8-myjobname2-host.vpshere.local]}' --extra-var='{"target_vcs": [nested8-myjobname-VC.vpshere.local]}' --extra-var esximemory="65536" --extra-var esxicpu="16"

time ansible-playbook -i hosts main.yml --extra-var version="7" --extra-var='{"target_hosts": [nested7-myjobname1-host.vpshere.local]}' --extra-var='{"target_vcs": [nested7-myjobname-VC.vpshere.local]}' --extra-var esximemory="65536" --extra-var esxicpu="16"

echo "rerun script for testing"

time ansible-playbook -i hosts main.yml --extra-var version="8" --extra-var='{"target_hosts": [nested8-myjobname1-host.vpshere.local,nested8-myjobname2-host.vpshere.local]}' --extra-var='{"target_vcs": [nested8-myjobname-VC.vpshere.local]}' --extra-var esximemory="65536" --extra-var esxicpu="16"

time ansible-playbook -i hosts main.yml --extra-var version="7" --extra-var='{"target_hosts": [nested7-myjobname1-host.vpshere.local]}' --extra-var='{"target_vcs": [nested7-myjobname-VC.vpshere.local]}' --extra-var esximemory="65536" --extra-var esxicpu="16"

echo "done"
