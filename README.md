# nested-ova-ansible
Create a dynamic vsphere setup (using DHCP)

You will need a server to host your ova files via http. I suggest miniserve (https://github.com/svenstaro/miniserve) or you could use some type of s3 bucket. You will also need a DHCP server on your network that you create your nested vSphere in.

I got my ESXi ova from William Lam (https://williamlam.com/)
I got my vCenter ova from the vCenter install ISO (download from VMware/Broadcom)

Look at file runitall.sh for examples on how to run

You will need to set up your physical host to have your vSwitch or your DVS set to:
Promiscuous mode accept
MAC address changes accept
Forged transmits accept

Also if you are running on top of a vSAN don't forget this:  esxcli system settings advanced set -o /VSAN/FakeSCSIReservations -i 1


PS. This code is a work in progress to have more features/options. So if you see stuff and wonder why is that there or remarked out. Debugging for new features and options in the future.
