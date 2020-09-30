#!/bin/bash

read -p "Enter the path to the nmap file: " file

masterarray=($(cat $file | grep -E "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b|\b+\/tcp\s*open" | awk '{print $NF}'))
ips=()
ip=""
services=($(awk '$0~/tcp\s+\open\s+(.+)/ { print $NF }' $file | sort | uniq))
count=0

for ((x=0;x<${#services[@]};x++));do
	count=0
	ips=()
	for ((i=0;i<${#masterarray[@]};++i));do
		if [[ "${masterarray[i]}" =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]; then
                        ip="${masterarray[i]}"
                fi

		if [[ "${masterarray[i]}" == "${services[x]}" ]]; then
			if [[ ! "${ips[@]}" =~ "$ip" ]]; then
				ips+=($ip)
				((count=count+1))
			fi
		fi
	done

	printf "Service: ${services[x]} Count: $count\n"
	printf "================================\n"
	for ((y=0;y<${#ips[@]};++y));do
		printf "${ips[y]}\n"
	done
	printf "\n"
done
