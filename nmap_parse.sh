#!/bin/bash

# Get the filepath from the user
read -p "Enter the path to the nmap file: " file

# Grep all the IPs and services and place them into one big array. Able to ignore IPs with no open ports that show as filtered. Can find TCP and UDP services
masterarray=($(cat $file | grep -E "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b$|\b+\/tcp\s*open|\b+\/udp\s*open" | awk '{print $NF}'))

# Create empty array to store IPs
ips=()

# Initialize a null string for storing current IP
ip=""

# Create an array of unique services found in the nmap file. Can find both TCP and UDP now.
services=($(awk '$0~/open/ { print $NF }' $file | sort | uniq))

# Count variable to increment
count=0

# For loop to go through each unique service
for ((x=0;x<${#services[@]};x++));do

        # Set count and IPs back to noting at the start of each service.
        count=0
        ips=()

        # Loop through master array
        for ((i=0;i<${#masterarray[@]};++i));do

                # If the item in the master array is an IP set $ip to its value
                if [[ "${masterarray[i]}" =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]; then
                        ip="${masterarray[i]}"
                 fi

                # If the item in the master array matches the service in the parent loop
                if [[ "${masterarray[i]}" == "${services[x]}" ]]; then

                        # If the current value of ip is not in the ips array add it add increment the count.
                        if [[ ! "${ips[@]}" =~ "$ip" ]]; then
                                ips+=($ip)
                                ((count=count+1))
                        fi
                fi
        done

        # Print the results
        printf "Service: ${services[x]} Count: $count\n"
        printf "================================\n"
        for ((y=0;y<${#ips[@]};++y));do
		printf "${ips[y]}\n"
        done
        printf "\n"
done
