#!/bin/bash

clear
echo ""
echo -e "======================"
echo -e "|    Membuat Akun    |"
echo -e "----------------------"
echo -e ""
read -p "Username      > " Login
read -p "Password      > " Pass
read -p "Expired (hari) > " Activetime
read -p "Apakah yakin ingin membuat akun ini ? [Y/n] " Jawaban
echo -e ""
if [[ $Jawaban =~ ^([yY])$ ]]
        then
			IP=$(wget -qO- ipv4.icanhazip.com);
			useradd -e `date -d "$Activetime days" +"%Y-%m-%d"` -s /bin/false -M $Login
			exp="$(chage -l $Login | grep "Account expires" | awk -F": " '{print $2}')"
			echo -e "$Pass\n$Pass\n"|passwd $Login &> /dev/null
			echo -e ""
			echo -e "Sukses membuat akun !"
			sleep 0.5
			echo -e ""
			echo -e "========================="
			echo -e "|     Informasi Akun    |"
			echo -e "-------------------------"
			echo -e ""
			echo -e "Host                     : $IP"
			echo -e "Username                 : $Login"
			echo -e "Password                 : $Pass"
			echo -e "Expired                  : $exp"
			echo -e "Port OpenSSH             : 22,444"
			echo -e "Port Dropbear            : 143,80"
			echo -e "Port SSL                 : 443"
			echo -e "Port Squid               : 80,8000,8989,8080"
			echo -e "BadVPN UDPGW             : 7300,7200"
			echo -e "OpenVPN TCP              : 1194"
			echo -e "OpenVPN SSL              : 2905,9443"
			echo -e "OpenVPN UDP              : 25000"
			echo -e "OpenVPN File TCP         : http://$IP:81/client-tcp-1194.ovpn"
			echo -e "                           http://$IP:81/client-tcp-9994.ovpn"
			echo -e "OpenVPN File UDP         : http://$IP:81/client-udp-25000.ovpn"
			echo -e "OpenVPN File SSL         : http://$IP:81/client-ssl-2905.ovpn"
			echo -e "                           http://$IP:81/client-ssl-9443.ovpn"
			echo -e "OpenVPN File Instagram   : http://$IP:81/instagram.ovpn"
			echo -e "OpenVPN File ZIP         : http://$IP:81/client-config.zip"
			echo -e ""
		else
			echo -e ""
fi