#!/bin/bash
#
#----------------------------------------------------------
#
# Name: vm_manage.sh
#
# Author: Michał Kacprzak										
#														
# Description: Script to automate managaing VMs 
#														
#----------------------------------------------------------

shutdown_all(){

	operation="$1" # shutdown or destroy

	for VM in $(virsh list --name)
		do
			virsh "$operation" "$VM" &> /dev/null
		done

}

manage_group(){

	groupfile="$1"
	groupname="$2"
	operation="$3"
	snapshot_name="$4"

	if [[ ! -f "$groupfile" ]]; then
		echo "Group file does not exist"
		exit 1
	fi
	
	case "$operation"
		in
			start)
				virsh_command="virsh start"
				;;
			shutdown)
				virsh_command="virsh shutdown"
				;;
			destroy)
				virsh_command="virsh destroy"
				;;
			create_snapshot)
				virsh_command="virsh snapshot-create-as --name $snapshot_name --domain"
				;;
			restore_snapshot)
				virsh_command="virsh snapshot-revert --snapshotname $snapshot_name --domain"
				;;
	esac

	MATCH=false
	while read line
		do
			if [[ "$line" =~ ^\[.*\]$ ]]; then
				if [[ "$line" != "[$groupname]" ]]; then
					MATCH=false
				else
					MATCH=true
					continue
				fi
			fi

			if [[ "$MATCH" = true ]]; then
				$virsh_command "$line" &> /dev/null
			fi
		done < "$groupfile"
}

show_help(){
	echo "Syntax: $(basename $0) [OPTION]"
	echo "-f specify group file"
	echo "-o specify option: start|shutdown|destroy|create_snapshot|restore_snapshot"
	echo "-m specify group name"
	echo "-s shutdown all VMs"
	echo "-d destroy all VMs"
	echo "-h show help"

}

## MAIN BLOCK ##

if [[ $(id -u) -ne 0 ]]; then
	echo "You must run script as root"
	exit 1
fi

while getopts "f: o: n: m: s d h" option
	do
		case "$option"
			in
				f) 	file="$OPTARG";;
				o)	operation="$OPTARG";;
				n)	snapshot_name="$OPTARG";;
				m)	manage_group  "$file" "$OPTARG" "$operation" "$snapshot_name";;
				s)	shutdown_all shutdown;;
				d)	shutdown_all destroy;;
				h) 	show_help;;
				*)	show_help;;
		esac
	done
