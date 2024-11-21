# nested-ova-ansible

Provisions nested vCenter and ESXi hosts.

## Prerequisites

- Ansible
- ESXi and vCenter OVAs hosted on an unauthenticated HTTP(S) server. For example: 
    ```bash
    python -m http.server
    ```
  or https://github.com/svenstaro/miniserve
- DHCP server on the hosting environment port group
- Set up your physical host to have your vSwitch or your DVS set to:
    - [x] Promiscuous mode accept
    - [x] MAC address changes accept
    - [x] Forged transmits accept
  Note: If using DVS 6.6+ set `MAC learning` Status to `ENABLED` (leave the defaults). Additionally, set `Forge Transmits` to `Accept`, `Promiscuous` to `Reject`, and `MAC address changes` to `Reject`.
- If environment is deployed to a vSAN in the hosting vCenter:
  ```bash
  esxcli system settings advanced set -o /VSAN/FakeSCSIReservations -i 1
  ```
- [`platform.yaml`](https://github.com/openshift/api/blob/master/config/v1/types_infrastructure.go#L1360) which defines the topology to be deployed

### Environment Variables

- `GOVC_URL`                 - URL of the vCenter hosting the nested environment
- `GOVC_USERNAME`            - Username of the account used to provision resources in the hosting environment
- `GOVC_PASSWORD`            - Password of the account used to provision resources in the hosting environment
- `GOVC_DATACENTER`          - Datacenter in the hosting environment where the nested environment will be deployed
- `GOVC_DATASTORE`           - Datastore in the hosting environment where the nested environment will be deployed
- `GOVC_CLUSTER`             - Cluster in the hosting environment where the nested environment will be deployed
- `GOVC_NETWORK`             - Portgroup in the hosting environment where the nested environment will be deployed
- `CLUSTER_NAME`             - Defines the prefix of the name of VMs associated with the nested environment
- `NESTED_PASSWORD`          - the password applied to the accounts administrator@vsphere.local (vCenter) and root (ESXi)
- `HOSTS_PER_FAILURE_DOMAIN` - optional: the number of hosts to deploy in each failure domain. default is 1
- `VCPUS`                    - optional: the number of vCPUs assigned to the nested VMs. The resources required for the vCenter(s) are not to be included. The default is 24 vCPUs
- `MEMORY`                   - optional: the amount of memory in GB assigned to the nested VMs. The resources required for the vCenter(s) are not to be included. The default is 96 GB
- `DISKGB`                   - optional: the amount of disk space in GB assigned to the nested host local datastore. The resources required for the vCenter(s) are not to be included. The default is 1024 GB

### Defining Media Assets

Bespoke versions of vCenter and ESXi can deployed by defining elements in the `vc_assets` list in `group_vars/all.yml`. For example:

```yaml
vc_assets:
- {
  'name': 'VC7.0.3.01400-21477706-ESXi7.0u3q',
  'esxiova': 'Nested_ESXi7.0u3q_Appliance_Template_v1.ova',
  'vcenterova': 'VMware-vCenter-Server-Appliance-7.0.3.01400-21477706_OVF10.ova',
  'httpova': "10.93.245.232:8080"
}
- {
  'name': 'VC8.0.2.00100-22617221-ESXi8.0u2c', 
  'esxiova': 'Nested_ESXi8.0u2c_Appliance_Template_v1.ova',
  'vcenterova': 'VMware-vCenter-Server-Appliance-8.0.2.00100-22617221_OVF10.ova',
  'httpova': "10.93.245.232:8080",
  'default': "true"
}
```

By default, the default asset will be chosen. If a specific version is created.

### Defining Shared Datastores

Shared NFS datastores can be attached to hosts by defining them in the `vc_nfs_shares` list in `group_vars/all.yml`. For example:

```yaml
vc_nfs_shares: 
- {
  "server": "161.26.99.159",
  "name": "dsnested",
  "path": "/DSW02SEV2284482_22/data01",
  'type': 'nfs41', 
  'nfs_ro': 'true',
  'failure_domains': []
}
```

By default, defined datastores are mounted to each host. If failure domains are defined, only hosts in those defined
`failure_domains` will have the datastore mounted. `failure_domains` is an array of failure domains names.

### Host Capacity Distribution

`VCPUS` and `MEMORY` define the total resources to be used by _all_ of the deployed hosts. For example, if 4 hosts are deployed each host will receive (VCPUS / 4) vCPUs. 

By default, only a single host is deployed per failure domain. If additional hosts are needed, the environment variable `HOSTS_PER_FAILURE_DOMAIN` can be configured to an integer which defines the number of hosts to create per failure domain.

Practically, there should be a maximum of 4 hosts when using the default resource allocation. 

## Running the tool

```bash
# Export variables
export GOVC_URL=...
export GOVC_USERNAME=...
export GOVC_PASSWORD=...
export GOVC_DATACENTER=...
export GOVC_DATASTORE=...
export GOVC_CLUSTER=...
export GOVC_NETWORK=...
export CLUSTER_NAME=...
export MAINVCPASSWORD=...
export HOSTS_PER_FAILURE_DOMAIN=...
export VCPUS=...
export MEMORY=...
ansible-playbook -i hosts main_nested.yml --extra-var version="VC8.0.2.00100-22617221-ESXi8.0u2c"
```

Note: `version` is optional if there is a `default` asset defined.

## Configuring Topology

Topology is configured by parsing the same [platform spec](https://github.com/openshift/api/blob/master/config/v1/types_infrastructure.go#L1360) used by the machine API, infrastructure resource, and installer in OpenShift. This allows the deployment of complex topologies. The platform spec(`platform.yaml`), by default, is located in the same directory where ansible is run.

We'll look at some common topologies. These examples are not exclusive.

### Single Failure Domain

Resource Allocation:
- 24 vCPUs
- 96 GB of RAM

`platform.yaml`:
```yaml
platform:
  vsphere:
    vcenters:
      - server: vcenter-1
        datacenters:
        - cidatacenter-nested-0
    failureDomains:
      - server: vcenter-1
        name: "cidatacenter-nested-0-cicluster-nested-0"
        zone: "cidatacenter-nested-0-cicluster-nested-0"
        region: cidatacenter-nested-0
        topology:
          resourcePool: /cidatacenter-nested-0/host/cicluster-nested-0/Resources/ipi-ci-clusters
          computeCluster: /cidatacenter-nested-0/host/cicluster-nested-0
          datacenter: cidatacenter-nested-0
          datastore: /cidatacenter-nested-0/datastore/dsnested
          networks:
            - "VM Network"
```

What does this provision?
- [x] single vCenter
    - [x] tag categories 
    - [x] 1 datacenter
        - [x] attach region tag
        - [x] 1 cluster
            - [x] attach zone tag
            - [x] 1 resource pool
            - [x] 1 ESXi host
                - [x] 24 vCPUs
                - [x] 96 GB RAM

Note: The vCenter is deployed alongside the nested hosts, not within the nested hosts.

### Two Failure Domains in Two Clusters

Resource Allocation:
- 24 vCPUs
- 96 GB of RAM

`platform.yaml`:
```yaml
platform:
  vsphere:
    vcenters:
      - server: vcenter-1
        datacenters:
        - cidatacenter-nested-0
    failureDomains:
      - server: vcenter-1
        name: "cidatacenter-nested-0-cicluster-nested-0"
        zone: "cidatacenter-nested-0-cicluster-nested-0"
        region: cidatacenter-nested-0
        topology:
          resourcePool: /cidatacenter-nested-0/host/cicluster-nested-0/Resources/ipi-ci-clusters
          computeCluster: /cidatacenter-nested-0/host/cicluster-nested-0
          datacenter: cidatacenter-nested-0
          datastore: /cidatacenter-nested-0/datastore/dsnested
          networks:
            - "VM Network"
      - server: vcenter-1
        name: "cidatacenter-nested-0-cicluster-nested-1"
        zone: "cidatacenter-nested-0-cicluster-nested-1"
        region: cidatacenter-nested-0
        topology:
          resourcePool: /cidatacenter-nested-0/host/cicluster-nested-1/Resources/ipi-ci-clusters
          computeCluster: /cidatacenter-nested-0/host/cicluster-nested-1
          datacenter: cidatacenter-nested-0
          datastore: /cidatacenter-nested-0/datastore/dsnested
          networks:
            - "VM Network"            
```

What does this provision?
- [x] vCenter: vcenter-1
    - [x] tag categories 
    - [x] datacenter: cidatacenter-nested-0
        - [x] attach region tag: cidatacenter-nested-0
        - [x] cluster: cicluster-nested-0
            - [x] attach zone tag: cidatacenter-nested-0-cicluster-nested-0
            - [x] 1 resource pool: ipi-ci-clusters
            - [x] 1 ESXi host
                - [x] 12 vCPUs
                - [x] 48 GB RAM
                - [x] Attach NFS Datastore(s)
        - [x] cluster: cicluster-nested-1
            - [x] attach zone tag: cidatacenter-nested-0-cicluster-nested-1
            - [x] 1 resource pool: ipi-ci-clusters
            - [x] 1 ESXi host
                - [x] 12 vCPUs
                - [x] 48 GB RAM
                - [x] Attach NFS Datastore(s)

### Two vCenters with a Single Failure Domain in Each

Resource Allocation:
- 24 vCPUs
- 96 GB of RAM

`platform.yaml`:
```yaml
platform:
  vsphere:
    vcenters:
      - server: vcenter-1
        datacenters:
        - cidatacenter-nested-0
      - server: vcenter-2
        datacenters:
        - cidatacenter-nested-1    
    failureDomains:
      - server: vcenter-1
        name: "cidatacenter-nested-0-cicluster-nested-0"
        zone: "cidatacenter-nested-0-cicluster-nested-0"
        region: cidatacenter-nested-0
        topology:
          resourcePool: /cidatacenter-nested-0/host/cicluster-nested-0/Resources/ipi-ci-clusters
          computeCluster: /cidatacenter-nested-0/host/cicluster-nested-0
          datacenter: cidatacenter-nested-0
          datastore: /cidatacenter-nested-0/datastore/dsnested
          networks:
            - "VM Network"
      - server: vcenter-2
        name: "cidatacenter-nested-1-cicluster-nested-1"
        zone: "cidatacenter-nested-1-cicluster-nested-1"
        region: cidatacenter-nested-1
        topology:
          resourcePool: /cidatacenter-nested-1/host/cicluster-nested-1/Resources/ipi-ci-clusters
          computeCluster: /cidatacenter-nested-1/host/cicluster-nested-1
          datacenter: cidatacenter-nested-1
          datastore: /cidatacenter-nested-1/datastore/dsnested
          networks:
            - "VM Network"            
```

What does this provision?
- [x] vCenter: vcenter-1
    - [x] tag categories 
    - [x] datacenter: cidatacenter-nested-0
        - [x] attach region tag: cidatacenter-nested-0
        - [x] cluster: cicluster-nested-0
            - [x] attach zone tag: cidatacenter-nested-0-cicluster-nested-0
            - [x] 1 resource pool: ipi-ci-clusters
            - [x] 1 ESXi host
                - [x] 12 vCPUs
                - [x] 48 GB RAM
                - [x] Attach NFS Datastore(s)
- [x] vCenter: vcenter-2
    - [x] tag categories 
    - [x] datacenter: cidatacenter-nested-1
        - [x] attach region tag: cidatacenter-nested-1
        - [x] cluster: cicluster-nested-1
            - [x] attach zone tag: cidatacenter-nested-1-cicluster-nested-1
            - [x] 1 resource pool: ipi-ci-clusters
            - [x] 1 ESXi host
                - [x] 12 vCPUs
                - [x] 48 GB RAM
                - [x] Attach NFS Datastore(s)

### Failure Domain with HostGroup

Resource Allocation:
- 24 vCPUs
- 96 GB of RAM

`platform.yaml`:
```yaml
platform:
  vsphere:
    vcenters:
      - server: vcenter-1
        user: "administrator@vsphere.local"
        password: "${vcenter_password}"
        datacenters:
        - cidatacenter-nested-0
    failureDomains:
      - server: vcenter-1
        name: "cidatacenter-nested-0-cicluster-nested-0"
        zone: "cidatacenter-nested-0-cicluster-nested-0"
        region: cidatacenter-nested-0
        zoneAffinity: "HostGroup"
        topology:
          resourcePool: /cidatacenter-nested-0/host/cicluster-nested-0/Resources/ipi-ci-clusters
          computeCluster: /cidatacenter-nested-0/host/cicluster-nested-0
          datacenter: cidatacenter-nested-0
          datastore: /cidatacenter-nested-0/datastore/dsnested
          networks:
            - "VM Network"
```

What does this provision?
- [x] vCenter: vcenter-1
    - [x] tag categories 
    - [x] datacenter: cidatacenter-nested-0
        - [x] attach region tag: cidatacenter-nested-0
        - [x] cluster: cicluster-nested-0
        - [x] resource pool: ipi-ci-clusters
        - [x] host group: cidatacenter-nested-0-cicluster-nested-0
            - [x] 1 ESXi host
            - [x] attach zone tag: cidatacenter-nested-0-cicluster-nested-0
                - [x] 24 vCPUs
                - [x] 96 GB RAM

### Skip Tagging Failure Domain(s)

Some configurations may dictate that tags not be attached to resources. For individual failiure domains, this can be done by preceding the zone or region name with a `-`. For example, `zone: "-cidatacenter-nested-0-cicluster-nested-0"` would result in the zone not being tagged for that failure domain.

If tagging is to be completely disabled define the environment variable `SKIP_FAILURE_DOMAIN_TAGGING=true`.

### Configuring Variables

By default, no additional variables are required. However, if `/tmp/override-vars.yaml` is present, it will be loaded and will override defaults or allow undefined variables to be defined.