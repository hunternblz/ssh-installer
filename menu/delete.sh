#!/bin/bash

clear
echo -e ""
echo -e "======================"
echo -e "|     Hapus Akun     |"
echo -e "----------------------"
echo -e ""
read -p "Username > " Users
echo -e ""
read -p "Apakah yakin ingin menghapus $Users ? [Y/n] " Jawaban
echo -e ""
if [[ $Jawaban =~ ^([yY])$ ]]
        then
                if getent passwd $Users > /dev/null 2>&1;
                        then
                                userdel $Users
                                echo -e "========================================================="
                                echo -e "|   Username ($Users) sudah dihapus.   |"
                                echo -e "---------------------------------------------------------"
                                echo -e ""
                        else
                                echo -e "======================================"
                                echo -e "|   Username ($Users) tidak ada.   |"
                                echo -e "--------------------------------------"
                                echo -e
                                echo -e "Untuk melihat user ketik 'member'"
                                echo -e ""
                fi
        else
                echo -e ""
fi
