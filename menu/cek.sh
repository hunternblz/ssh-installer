#!/bin/bash

data=( `ps aux | grep -i dropbear | awk '{print $2}'`);
echo ""
echo "================================"
echo "|   Login Port Dropbear & SSL  |"
echo "--------------------------------"

for PID in "${data[@]}"
do
        NUM=`cat /var/log/auth.log | grep -i dropbear | grep -i "Password auth succeeded" | grep "dropbear\[$PID\]" | wc -l`;
        USER=`cat /var/log/auth.log | grep -i dropbear | grep -i "Password auth succeeded" | grep "dropbear\[$PID\]" | awk '{print $10}'`;
        IP=`cat /var/log/auth.log | grep -i dropbear | grep -i "Password auth succeeded" | grep "dropbear\[$PID\]" | awk '{print $12}'`;
        if [ $NUM -eq 1 ]; then
        echo "$PID - $USER - $IP";
        fi
done

echo "";

data=( `ps aux | grep "\[priv\]" | sort -k 72 | awk '{print $2}'`);
echo ""
echo "=========================="
echo "|   Login Port OpenSSH   |"
echo "--------------------------"

for PID in "${data[@]}"
do
        NUM=`cat /var/log/auth.log | grep -i sshd | grep -i "Accepted password for" | grep "sshd\[$PID\]" | wc -l`;
        USER=`cat /var/log/auth.log | grep -i sshd | grep -i "Accepted password for" | grep "sshd\[$PID\]" | awk '{print $9}'`;
        IP=`cat /var/log/auth.log | grep -i sshd | grep -i "Accepted password for" | grep "sshd\[$PID\]" | awk '{print $11}'`;
        if [ $NUM -eq 1 ]; then
                echo "$PID - $USER - $IP";
        fi
done

echo "";

echo ""
echo "=================================="
echo "|  *Penggunaan > kill nomor PID  |"
echo "----------------------------------"
echo "";
echo "";
