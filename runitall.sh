#!/bin/bash
#ansible-playbook -i hosts main.yml --extra-var version="8" --extra-var='{"target_hosts": [nested8-myjobname-host.vpshere.local,nested8-myjobname-host1.vsphere.local]}'
#ansible-playbook -i hosts main.yml --extra-var version="8" --extra-var='{"target_hosts": [nested8-myjobname1-host.vpshere.local,nested8-myjobname2-host.vpshere.local]}' --extra-var='{"target_vcs": [nested8-myjobname-VC.vpshere.local]}' --extra-var testingesxi=true --extra-var testingvc=true
#ansible-playbook -i hosts main.yml --extra-var version="8" --extra-var='{"target_hosts": [nested8-myjobname1-host.vpshere.local,nested8-myjobname2-host.vpshere.local]}' --extra-var='{"target_vcs": [nested8-myjobname-VC.vpshere.local]}' --extra-var testingesxi=false --extra-var testingvc=false



ansible-playbook -i hosts main.yml --extra-var version="8" --extra-var='{"target_hosts": [nested8-myjobname1-host.vpshere.local,nested8-myjobname2-host.vpshere.local]}' --extra-var='{"target_vcs": [nested8-myjobname-VC.vpshere.local]}' 

echo "sleep for 1 hour"
sleep 3600

ansible-playbook -i hosts main.yml --extra-var version="8" --extra-var='{"target_hosts": [nested8-myjobname1-host.vpshere.local,nested8-myjobname2-host.vpshere.local]}' --extra-var='{"target_vcs": [nested8-myjobname-VC.vpshere.local]}' --extra-var removevsphere=true -t removevsphere
