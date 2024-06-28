#!/usr/bin/env bash

token=""
chat="722262978"
ipfile="$HOME/ip.scripts/db_ip.txt"
logfile="$HOME/ip.scripts/logfile.txt"

#namecheap update dns

password="9e226e5d5eee470391b330d1c2af1eff"
hosts=("*" "@")
domain="syszima.xyz"



ip=$(curl -s ipinfo.io | grep '"ip"' | grep -Eo "[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+")

#ip=$(curl -s ipinfo.io | awk '/[0-9]{3,}/ {print $NF}' | head -n1 | tr -d ',\"')

if ! [[ -f "$ipfile" ]]; then
	echo "$ip" > "$ipfile"
fi

read -r previp < "$ipfile"

if [[ $previp != "$ip" ]]; then
	msg="$(date): IP change from '$previp' to '$ip'"
	echo "$msg" >> $logfile
	echo "$ip" > "$ipfile"

	curl -s -X POST https://api.telegram.org/bot$token/sendMessage -d chat_id=$chat -d text="$msg" &&

	for host in "${hosts[@]}"; do

	    curl -s "https://dynamicdns.park-your-domain.com/update?host=$host&domain=$domain&password=$password"

	done
else
	msg="$(date): IP didn't change: '$previp'"

	curl -s -X POST https://api.telegram.org/bot$token/sendMessage -d chat_id=$chat -d text="$msg"

fi
