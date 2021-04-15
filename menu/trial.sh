#!/bin/bash

IP=$(wget -qO- ipv4.icanhazip.com);
Login=trial`</dev/urandom tr -dc X-Z0-9 | head -c4`
hari="1"
Pass=`</dev/urandom tr -dc a-f0-9 | head -c9`
useradd -e `date -d "$hari days" +"%Y-%m-%d"` -s /bin/false -M $Login
echo -e "$Pass\n$Pass\n"|passwd $Login &> /dev/null
clear
echo -e "===== Account Information ====="
echo -e "SSH & OpenVPN"
echo -e "IP : $IP"
echo -e "Username : $Login"
echo -e "Password : $Pass"
echo -e "Port OpenSSH : 22, 444"
echo -e "Port Dropbear : 80, 143"
echo -e "Port SSL : 443"
echo -e "Port Squid : 80, 8000, 8080, 8989"
echo -e "BadVpn UDPGW : 7200, 7300"
echo -e "OpenVPN : SSL 2905, 9443 (Config : http://$IP:81/client-ssl-2905.ovpn | http://$IP:81/client-ssl-9443.ovpn)"
echo -e "OpenVPN : TCP 1194, 9994 (Config : http://$IP:81/client-tcp-1194.ovpn | http://$IP:81/client-tcp-9994.ovpn)"
echo -e "OpenVPN : UDP 25000 (Config : http://$IP:81/client-udp-25000.ovpn)"
echo -e "OpenVPN : Instagram (Config : http://$IP:81/instagram.ovpn)"
echo -e "OpenVPN : ZIP (Config : http://$IP:81/client-config.zip)"
echo -e "Expired : $hari Hari"
echo -e "==============================="
echo -e ""