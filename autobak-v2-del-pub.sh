#!/bin/bash

echo ==========autobakfiles Begin @ `date`==========

array_autobakserver=(xyr3 yfndr3 xdr3 audir3 zhr3 jpr3 ccr3 kingdee)
array_serverip=(253 243 29 252 249 233 245 235)
array_serversmbver=(0 0 1 1 1 0 1 1)
array_server_net=(1 1 250 1 1 1 1 1)
share_name=
share_password=


echo ther is ${#array_autobakserver[@]} server wait be sync, this process will take a long time,be patience...

index=0
for i in ${array_autobakserver[@]};
do
	echo -
	
	if [ ${array_serversmbver[$index]} -eq 1 ]; then
		smbver='vers=1.0,';
	else
		smbver='';
	fi
	
	if [ ${array_server_net[$index]} -eq 1 ]; then
		ip_prex='192.168.1.';
	else
		ip_prex='172.30.250.';
	fi

	echo ===== "$index" now is sync $i serverip is "$ip_prex"${array_serverip[$index]}=====

	if [ `mount | grep "$i" | wc -l` -eq 0 ]
	then 
		/usr/sbin/mount.cifs //"$ip_prex""${array_serverip[$index]}"/"$i"bak$ /mnt/"$i"bak -o "$smbver"username=$share_name,password=$share_password
		sleep 2
	fi

	if [ `ls -l /mnt/"$i"bak/ | wc -l` -eq 1 ]
	then
		echo "出问题了，请查看是否有异常";
	else
		echo there has `ls -l /mnt/"$i"bak/ | wc -l` files to be sync! 
		rsync -avz --del /mnt/"$i"bak/ /bak/"$i"/
	fi	

	umount /mnt/"$i"bak

	let index=($index+1)
	echo -
done


echo ======space use======

du -sh /bak
## this sh edited by Zengqiuming @2021 ##

echo ==========autobakfiles Ending @ `date`==========

