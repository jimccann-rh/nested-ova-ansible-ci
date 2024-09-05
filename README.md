# nested-ovf-ansible
Create a dynamic vsphere setup (using dhcp)

You will need a server to host your ovf files via http. I suggest: https://github.com/svenstaro/miniserve or you could use a s3 bucket. You will also need a dhcp server on your network that you create your nested vSphere in.:w


I got my ESXi ova from William Lam (just google)
I got my vCenter ova from the vCenter install ISO (download from vmware)

look at file runitall.sh for examples on how to run


You will need to set up your physical host to have your vswitch or your dvs:
Promiscuous mode accept
MAC address changes accept
Forged transmits accept

Also if you are running on top of a vSAN don't forget this:  esxcli system settings advanced set -o /VSAN/FakeSCSIReservations -i 1

