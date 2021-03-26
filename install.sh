#!/bin/bash

clear
apt-get install ruby -y
ruby --version
wget https://github.com/busyloop/lolcat/archive/master.zip
unzip master.zip
cd lolcat-master/bin
gem install lolcat
clear
rm -rf ssh-installer
apt-get -y install nginx php-fpm php-cli
NIC=$(ip -4 route ls | grep default | grep -Po '(?<=dev )(\S+)' | head -1)
export DEBIAN_FRONTEND=noninteractive
OS=`uname -m`;
MYIP=$(wget -qO- ipv4.icanhazip.com);
echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6
sed -i '$ i\echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6' /etc/rc.local
echo 1 > /proc/sys/net/ipv4/ip_forward
sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/g' /etc/sysctl.conf
sysctl -p
mkdir -p /etc/iptables
apt-get install -y openvpn easy-rsa iptables openssl ca-certificates gnupg
apt-get install -y net-tools
cp -r /usr/share/easy-rsa /etc/openvpn
cd /etc/openvpn
cd easy-rsa
sed -i 's|export KEY_COUNTRY="US"|export KEY_COUNTRY="ID"|' /etc/openvpn/easy-rsa/vars
sed -i 's|export KEY_PROVINCE="CA"|export KEY_PROVINCE="ID"|' /etc/openvpn/easy-rsa/vars
sed -i 's|export KEY_CITY="SanFrancisco"|export KEY_CITY="ID"|' /etc/openvpn/easy-rsa/vars
sed -i 's|export KEY_ORG="Fort-Funston"|export KEY_ORG="HunterNblz"|' /etc/openvpn/easy-rsa/vars
sed -i 's|export KEY_EMAIL="me@myhost.mydomain"|export KEY_EMAIL="admin@nabil.my.id"|' /etc/openvpn/easy-rsa/vars
sed -i 's|export KEY_OU="MyOrganizationalUnit"|export KEY_OU="HunterNblz"|' /etc/openvpn/easy-rsa/vars
sed -i 's|export KEY_NAME="EasyRSA"|export KEY_NAME="HunterNblz"|' /etc/openvpn/easy-rsa/vars
sed -i 's|export KEY_OU=changeme|export KEY_OU=HunterNblz|' /etc/openvpn/easy-rsa/vars
cp openssl-1.0.0.cnf openssl.cnf
source ./vars
./clean-all
source vars
rm -rf keys
./clean-all
./build-ca
./build-key-server server
./pkitool --initca
./pkitool --server server
./pkitool client
./build-dh
cp keys/ca.crt /etc/openvpn
cp keys/server.crt /etc/openvpn
cp keys/server.key /etc/openvpn
cp keys/dh2048.pem /etc/openvpn
cp keys/client.key /etc/openvpn
cp keys/client.crt /etc/openvpn

echo 'port 1194
proto tcp
dev tun
ca ca.crt
cert server.crt
key server.key
dh dh2048.pem
persist-key
persist-tun
keepalive 10 120
duplicate-cn
server 10.8.0.0 255.255.255.0
ifconfig-pool-persist ipp.txt
plugin /usr/lib/openvpn/openvpn-plugin-auth-pam.so login
client-cert-not-required
username-as-common-name
push "redirect-gateway def1 bypass-dhcp"
push "dhcp-option DNS 8.8.8.8"
push "dhcp-option DNS 8.8.4.4"
comp-lzo
status server-tcp-1194.log
verb 3' >/etc/openvpn/server-tcp-1194.conf

echo 'port 9994
proto tcp
dev tun
ca ca.crt
cert server.crt
key server.key
dh dh2048.pem
persist-key
persist-tun
keepalive 10 120
duplicate-cn
server 10.9.0.0 255.255.255.0
ifconfig-pool-persist ipp.txt
plugin /usr/lib/openvpn/openvpn-plugin-auth-pam.so login
client-cert-not-required
username-as-common-name
push "redirect-gateway def1 bypass-dhcp"
push "dhcp-option DNS 8.8.8.8"
push "dhcp-option DNS 8.8.4.4"
comp-lzo
status server-tcp-9994.log
verb 3' >/etc/openvpn/server-tcp-9994.conf

echo 'port 25000
proto udp
dev tun
ca ca.crt
cert server.crt
key server.key
dh dh2048.pem
persist-key
persist-tun
keepalive 10 120
duplicate-cn
server 20.8.0.0 255.255.255.0
ifconfig-pool-persist ipp.txt
plugin /usr/lib/openvpn/openvpn-plugin-auth-pam.so login
client-cert-not-required
username-as-common-name
push "redirect-gateway def1 bypass-dhcp"
push "dhcp-option DNS 8.8.8.8"
push "dhcp-option DNS 8.8.4.4"
comp-lzo
status server-udp-25000.log
verb 3' >/etc/openvpn/server-udp-25000.conf

systemctl enable openvpn
service openvpn restart
cd

echo "client
dev tun
proto tcp
remote $MYIP 1194
resolv-retry infinite
route-method exe
nobind
persist-key
persist-tun
auth-user-pass
comp-lzo
verb 3

" >/var/www/html/client-tcp-1194.ovpn

echo "client
dev tun
proto tcp
remote $MYIP 9994
resolv-retry infinite
route-method exe
nobind
persist-key
persist-tun
auth-user-pass
comp-lzo
verb 3

" >/var/www/html/client-tcp-9994.ovpn

echo "client
dev tun
proto udp
remote $MYIP 25000
resolv-retry infinite
route-method exe
nobind
persist-key
persist-tun
auth-user-pass
comp-lzo
verb 3

" >/var/www/html/client-udp-25000.ovpn

echo "client
dev tun
proto tcp
remote $MYIP 2905
resolv-retry infinite
route-method exe
nobind
persist-key
persist-tun
auth-user-pass
comp-lzo
verb 3

" >/var/www/html/client-ssl-2905.ovpn

echo "client
dev tun
proto tcp
remote $MYIP 9443
resolv-retry infinite
route-method exe
nobind
persist-key
persist-tun
auth-user-pass
comp-lzo
verb 3

" >/var/www/html/client-ssl-9443.ovpn

echo "client
dev tun
proto tcp
remote $MYIP 1194
http-proxy $MYIP 8080
http-proxy-option CUSTOM-HEADER CONNECT HTTP/1.1
http-proxy-option CUSTOM-HEADER Host m.instagram.com
http-proxy-option CUSTOM-HEADER X-Online-Host m.instagram.com
http-proxy-option CUSTOM-HEADER X-Forward-Host m.instagram.com
http-proxy-option CUSTOM-HEADER Connection Keep-Alive
resolv-retry infinite
route-method exe
nobind
persist-key
persist-tun
auth-user-pass
comp-lzo
verb 3

" >/var/www/html/instagram.ovpn

cd
apt-get install -y zip
cd /var/www/html

{
echo "<ca>"
cat "/etc/openvpn/ca.crt"
echo "</ca>"
} >>client-tcp-1194.ovpn

{
echo "<ca>"
cat "/etc/openvpn/ca.crt"
echo "</ca>"
} >>client-tcp-9994.ovpn

{
echo "<ca>"
cat "/etc/openvpn/ca.crt"
echo "</ca>"
} >>client-ssl-9443.ovpn

{
echo "<ca>"
cat "/etc/openvpn/ca.crt"
echo "</ca>"
} >>client-ssl-2905.ovpn

{
echo "<ca>"
cat "/etc/openvpn/ca.crt"
echo "</ca>"
} >>client-udp-25000.ovpn

{
echo "<ca>"
cat "/etc/openvpn/ca.crt"
echo "</ca>"
} >>instagram.ovpn

zip client-config.zip client-tcp-1194.ovpn client-tcp-9994.ovpn client-ssl-9443.ovpn client-ssl-2905.ovpn client-udp-25000.ovpn instagram.ovpn
apt-get install -y iptables iptables-persistent netfilter-persistent
iptables -t nat -A POSTROUTING -s 10.8.0.0/24 -o $NIC -j MASQUERADE
iptables -t nat -A POSTROUTING -s 10.9.0.0/24 -o $NIC -j MASQUERADE
iptables -t nat -A POSTROUTING -s 20.8.0.0/24 -o $NIC -j MASQUERADE
iptables-save > /etc/iptables/rules.v4
service openvpn restart
country=ID
state=Indonesia
locality=Cilacap
organization=HunterNblz
organizationalunit=HunterNblz
commonname=HunterNblz
email=admin@nabil.my.id
git clone https://github.com/hunternblz/ssh-installer
cd /root/ssh-installer/files
rm /etc/pam.d/common-password
mv common-password /etc/pam.d/
chmod +x /etc/pam.d/common-password
cd
cat > /etc/systemd/system/rc-local.service <<-END
[Unit]
Description=/etc/rc.local
ConditionPathExists=/etc/rc.local
[Service]
Type=forking
ExecStart=/etc/rc.local start
TimeoutSec=0
StandardOutput=tty
RemainAfterExit=yes
SysVStartPriority=99
[Install]
WantedBy=multi-user.target
END
cat > /etc/rc.local <<-END
exit 0
END
chmod +x /etc/rc.local
systemctl enable rc-local
systemctl start rc-local.service
apt-get update -y
apt-get install -y wget curl
apt -y autoremove
apt -y autoclean
apt -y clean
ln -fs /usr/share/zoneinfo/Asia/Jakarta /etc/localtime
sed -i 's/AcceptEnv/#AcceptEnv/g' /etc/ssh/sshd_config
apt-get update -y
apt-get install -y nginx
apt-get update -y
apt-get -y install gcc
apt-get -y install make
apt-get -y install cmake
apt-get -y install git
apt-get -y install screen
apt-get -y install unzip
apt-get -y install curl
apt-get -y install net-tools
git clone https://github.com/dylanaraps/neofetch
cd neofetch
make install
make PREFIX=/usr/local install
make PREFIX=/boot/home/config/non-packaged install
make -i install
apt-get -y install neofetch
cd
rm -rf neofetch
apt-get -y update
cd
rm /etc/nginx/sites-enabled/default
cd ssh-installer/nginx/
mv default /etc/nginx/sites-enabled/
cd
/etc/init.d/nginx restart
systemctl restart nginx
cd
apt-get install cmake make gcc -y
cd
wget https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/badvpn/badvpn-1.999.128.tar.bz2
tar xf badvpn-1.999.128.tar.bz2
mkdir badvpn-build
cd badvpn-build
cmake ~/badvpn-1.999.128 -DBUILD_NOTHING_BY_DEFAULT=1 -DBUILD_UDPGW=1
make install
cd
sed -i '$ i\screen -AmdS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300 --max-clients 500' /etc/rc.local
chmod +x /usr/bin/badvpn-udpgw
screen -AmdS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300 --max-clients 500
cd
rm -rf ssh-installer
git clone https://github.com/hunternblz/ssh-installer
cd ssh-installer/badvpn/
mv badvpn-udpgw /usr/bin/
sed -i '$ i\screen -AmdS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7200 --max-clients 500' /etc/rc.local
chmod +x /usr/bin/badvpn-udpgw
screen -AmdS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7200 --max-clients 500
cd
sed -i 's/#Port 22/Port 22/g' /etc/ssh/sshd_config
sed -i '/Port 22/a Port 444' /etc/ssh/sshd_config
service ssh restart
apt-get -y install dropbear
sed -i 's/NO_START=1/NO_START=0/g' /etc/default/dropbear
sed -i 's/DROPBEAR_PORT=22/DROPBEAR_PORT=143/g' /etc/default/dropbear
sed -i 's/DROPBEAR_EXTRA_ARGS=/DROPBEAR_EXTRA_ARGS="-p 142 -p 80"/g' /etc/default/dropbear
echo "/bin/false" >> /etc/shells
echo "/usr/sbin/nologin" >> /etc/shells
/etc/init.d/dropbear restart
cd
apt-get -y install squid3
echo "#acl manager proto cache_object
acl localhost src 127.0.0.1/32 ::1
acl to_localhost dst 127.0.0.0/8 0.0.0.0/32 ::1
acl SSL_ports port 443
acl Safe_ports port 80
acl Safe_ports port 21
acl Safe_ports port 443
acl Safe_ports port 70
acl Safe_ports port 210
acl Safe_ports port 1025-65535
acl Safe_ports port 280
acl Safe_ports port 488
acl Safe_ports port 591
acl Safe_ports port 777
acl CONNECT method CONNECT
acl SSH dst $MYIP-$MYIP/255.255.255.255
http_access allow SSH
http_access allow manager localhost
http_access deny manager
http_access allow localhost
http_access deny all
http_port 80
http_port 8080
http_port 8989
http_port 3128
coredump_dir /var/spool/squid3
refresh_pattern ^ftp: 1440 20% 10080
refresh_pattern ^gopher: 1440 0% 1440
refresh_pattern -i (/cgi-bin/|\?) 0 0% 0
refresh_pattern . 0 20% 4320
visible_hostname HunterNblz
" >/etc/squid/squid.conf
service squid restart
apt-get -y install vnstat
vnstat -u -i $NIC
service vnstat restart
apt-get install stunnel4 -y
cat > /etc/stunnel/stunnel.conf <<-END
cert = /etc/stunnel/stunnel.pem
client = no
socket = a:SO_REUSEADDR=1
socket = l:TCP_NODELAY=1
socket = r:TCP_NODELAY=1

[dropbear]
accept = 443
connect = 127.0.0.1:143

[dropbear]
accept = 9443
connect = 127.0.0.1:1194

[dropbear]
accept = 2905
connect = 127.0.0.1:9994

[dropbear]
accept = 990
connect = 127.0.0.1:22

END

openssl genrsa -out key.pem 2048
openssl req -new -x509 -key key.pem -out cert.pem -days 1095 \
-subj "/C=$country/ST=$state/L=$locality/O=$organization/OU=$organizationalunit/CN=$commonname/emailAddress=$email"
cat key.pem cert.pem >> /etc/stunnel/stunnel.pem
rm -f key.pem
rm -f cert.pem
sed -i 's/ENABLED=0/ENABLED=1/g' /etc/default/stunnel4
/etc/init.d/stunnel4 restart
cdLEDinstall fail2ban
apt-get -y install fail2ban
if [ -d '/usr/local/ddos' ]; then
	echo; echo; echo "Silakan hapus/uninstall dahulu versi sebelumnya"
	exit 0
else
	mkdir /usr/local/ddos
fi
echo; echo 'Menginstall DOS-Deflate 0.6'; echo
echo; echo -n 'Mendownload sumber file...'
wget -q -O /usr/local/ddos/ddos.conf http://www.inetbase.com/scripts/ddos/ddos.conf
echo -n '.'
wget -q -O /usr/local/ddos/LICENSE http://www.inetbase.com/scripts/ddos/LICENSE
echo -n '.'
wget -q -O /usr/local/ddos/ignore.ip.list http://www.inetbase.com/scripts/ddos/ignore.ip.list
echo -n '.'
wget -q -O /usr/local/ddos/ddos.sh http://www.inetbase.com/scripts/ddos/ddos.sh
chmod 0755 /usr/local/ddos/ddos.sh
cp -s /usr/local/ddos/ddos.sh /usr/local/sbin/ddos
echo '...selesai'
echo; echo -n 'Membuat cronjob untuk menjalankan setiap menit'
/usr/local/ddos/ddos.sh --cron > /dev/null 2>&1
echo '.....selesai'
echo; echo 'Penginstallan selesai.'
echo 'File config terletak pada /usr/local/ddos/ddos.conf'
cd
apt-get install -y libxml-parser-perl
cd ssh-installer/files
mv banner-ssh /etc/
echo 'File banner ssh terletak pada /etc/banner-ssh'
cd
sed -i 's@#Banner@Banner@g' /etc/ssh/sshd_config
sed -i 's@DROPBEAR_BANNER=""@DROPBEAR_BANNER="/etc/banner-ssh"@g' /etc/default/dropbear
cd ssh-installer/menu
mv menu.sh menu
mv usernew.sh usernew
mv trial.sh trial
mv member.sh member
mv delete.sh delete
mv cek.sh cek
mv restart.sh restart
mv info.sh info
mv live.sh live
mv cekmemory.py cekmemory
mv cekport.sh cekport
mv port.sh port
mv statport.sh statport
mv expired.sh expired
cd
echo "59 23 * * * root expired" >> /etc/crontab
echo "0 0 * * * root /sbin/reboot" > /etc/cron.d/reboot
cd ssh-installer/menu
cp -R menu /usr/bin
cp -R usernew /usr/bin
cp -R trial /usr/bin
cp -R member /usr/bin
cp -R delete /usr/bin
cp -R cek /usr/bin
cp -R restart /usr/bin
cp -R speedtest /usr/bin
cp -R info /usr/bin
cp -R live /usr/bin
cp -R cekmemory /usr/bin
cp -R cekport /usr/bin
cp -R port /usr/bin
cp -R statport /usr/bin
cp -R expired /usr/bin
chmod +x /usr/bin/menu
chmod +x /usr/bin/usernew
chmod +x /usr/bin/trial
chmod +x /usr/bin/member
chmod +x /usr/bin/delete
chmod +x /usr/bin/cek
chmod +x /usr/bin/restart
chmod +x /usr/bin/speedtest
chmod +x /usr/bin/info
chmod +x /usr/bin/live
chmod +x /usr/bin/cekmemory
chmod +x /usr/bin/cekport
chmod +x /usr/bin/port
chmod +x /usr/bin/statport
chmod +x /usr/bin/expired
cd
systemctl restart nginx
service openvpn restart
/etc/init.d/cron restart
/etc/init.d/ssh restart
/etc/init.d/sshd restart
service dropbear restart
/etc/init.d/fail2ban restart
screen -AmdS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300 --max-clients 500
screen -AmdS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7200 --max-clients 500
rm -rf /root/ssh-installer
rm /root/install.sh
port
restart ~/.bash_history && history -c
echo "unset HISTFILE" >> /etc/profile
read -p "Tekan enter untuk mereboot VPS"
reboot
