# vm_manage
Simple script to automate managing VMs.
In order to managing VMs you must create a group file. Here is an examplary file:
```
[group1]
vm1
vm2
vm3
[group2]
vm4
vm5
vm6

```
## Options
```-f groupfile``` - spcecify group file\
```-o start|shutdown|destroy|create_snapshot|restore_snapshot``` - specify option\
```-m groupname``` - specify group name\
```-s``` - shutdown all VMs\
```-d``` - destroy all VMs\
```-h``` - show help

## Examples
```vm_manage.sh -f groupfile -o start -m group1``` - start all VMs in group1 that are specified in groupfile\
```vm_manage.sh -f groupfile -o shutdown -m group2``` - shutdown all VMs in group2\
```vm_manage.sh -f groupfile -o create_snapshot -n snap_name -m group1``` - create snapshot "snap_name" for all VMs in group1
```vm_manage.sh -f groupfile -o restore_snapshot -n snap_name -m group1``` - restore all VMs in group1 to snapshot named "snap_name"
```vm_manage.sh -s``` - shutdown all VMs
