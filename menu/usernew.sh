#!/bin/bash

clear
echo ""
echo -e "======================"
echo -e "|    Membuat Akun    |"
echo -e "----------------------"
echo -e ""
read -p "Username > " Login
read -p "Password > " Pass
read -p "Expired (hari) > " Activetime
read -p "Apakah yakin ingin membuat akun ini ? [Y/N] > " Jawaban
echo -e ""
if [[ $Jawaban =~ ^([yY])$ ]]
        then
			IP=$(wget -qO- ipv4.icanhazip.com);
			useradd -e `date -d "$Activetime days" +"%Y-%m-%d"` -s /bin/false -M $Login
			exp="$(chage -l $Login | grep "Account expires" | awk -F": " '{print $2}')"
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
			echo -e "Expired : $exp"
			echo -e "==============================="
			echo -e ""
		else
			echo -e ""
fi