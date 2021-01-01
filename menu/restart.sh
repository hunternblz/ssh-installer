#!/bin/bash

echo -e ""
echo -e "RESTART PORT DROPBEAR . . ."
service dropbear restart
        if service dropbear restart
                then
                        echo "===================================="
                        echo "|   DROPBEAR BERHASIL DI RESTART   |"
                        echo "------------------------------------"
                else
                        echo "================================="
                        echo "|   DROPBEAR GAGAL DI RESTART   |"
                        echo "---------------------------------"
        fi
echo ""
echo -e "RESTART PORT OPENVPN . . ."
service openvpn restart
        if service openvpn restart
                then
                        echo "==================================="
                        echo "|   OPENVPN BERHASIL DI RESTART   |"
                        echo "-----------------------------------"
                else
                        echo "================================"
                        echo "|   OPENVPN GAGAL DI RESTART   |"
                        echo "--------------------------------"
         fi
echo ""
echo -e "RESTART PORT OPENSSH . . ."
service ssh restart
        if service ssh restart
                then
                        echo "==================================="
                        echo "|   OPENSSH BERHASIL DI RESTART   |"
                        echo "-----------------------------------"
                else
                        echo "================================"
                        echo "|   OPENSSH GAGAL DI RESTART   |"
                        echo "--------------------------------"
        fi
echo -e "RESTART PORT STUNNEL / SSL . . ."
/etc/init.d/stunnel4 restart
        if /etc/init.d/stunnel4 restart
                then
                        echo "========================================="
                        echo "|   STUNNEL / SSL BERHASIL DI RESTART   |"
                        echo "-----------------------------------------"
                else
                        echo "======================================"
                        echo "|   STUNNEL / SSL GAGAL DI RESTART   |"
                        echo "--------------------------------------"
        fi
service squid restart
        if service squid restart
                then
                        echo "======================================="
                        echo "|   SQUID PROXY BERHASIL DI RESTART   |"
                        echo "---------------------------------------"
                else
                        echo "===================================="
                        echo "|   SQUID PROXY GAGAL DI RESTART   |"
                        echo "------------------------------------"
        fi
netstat -tunlp
echo -e ""