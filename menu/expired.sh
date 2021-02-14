#!/bin/bash

if [ ! -d "/root/SSH-Log" ]; then
	mkdir /root/SSH-Log
fi
echo "" > /root/SSH-Log/infoUser.txt
echo "" > /root/SSH-Log/expiredUser.txt
echo "" > /root/SSH-Log/activeUser.txt
echo "" > /root/SSH-Log/allUser.txt
cat /etc/shadow | cut -d: -f1,8 | sed /:$/d > /tmp/expireList.txt
totalaccounts=`cat /tmp/expireList.txt | wc -l`
for ((i=1; i<=$totalaccounts; i++))
do
	tuserval=`head -n $i /tmp/expireList.txt | tail -n 1`
	username=`echo $tuserval | cut -f1 -d:`
	userexp=`echo $tuserval | cut -f2 -d:`
	userexpireinseconds=$(( $userexp * 86400 ))
	tglexp=`date -d @$userexpireinseconds`
	tgl=`echo $tglexp |awk -F" " '{print $3}'`
	while [ ${#tgl} -lt 2 ]
	do
		tgl="0"$tgl
	done
	while [ ${#username} -lt 15 ]
	do
		username=$username" "
	done
	bulantahun=`echo $tglexp |awk -F" " '{print $2,$6}'`
	echo " User : $username Expire tanggal : $tgl $bulantahun" >> /root/SSH-Log/allUser.txt
	todaystime=`date +%s`
	if [ $userexpireinseconds -ge $todaystime ]; then
		echo " User : $username Expire tanggal : $tgl $bulantahun" >> /root/SSH-Log/activeUser.txt
		timeto7days=$(( $todaystime + 604800 ))
		if [ $userexpireinseconds -le $timeto7days ]; then
			echo " User : $username Expire tanggal : $tgl $bulantahun" >> /root/SSH-Log/infoUser.txt
		fi
	else
		echo " User : $username Expire tanggal : $tgl $bulantahun" >> /root/SSH-Log/expiredUser.txt
		passwd -l $username
		userdel $username
	fi
done

