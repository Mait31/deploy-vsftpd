#!/bin/bash

sudo apt update
sudo apt install vsftpd
sudo openssl req -x509 -nodes -days 3650 -newkey rsa:2048 -keyout /etc/ssl/private/vsftpd.pem -out /etc/ssl/certs/vsftpd.pem -subj /C="DE"/ST="Saxony"/L="Leipzig"/CN="Ftp"
sudo mkdir /home/ftpuser
read -p "请设置您的ftp登录用户: " ftpuser
sudo useradd -m -d /home/ftpuser/$ftpuser -g ftp $ftpuser
echo "Enter password for $ftpuser"
sudo passwd $ftpuser

cat << EOF > /etc/vsftpd.conf
local_enable=YES
anonymous_enable=NO
write_enable=YES
local_umask=022

listen=YES
listen_port=21
listen_ipv6=NO
pasv_enable=YES
pasv_min_port=40000
pasv_max_port=45000

pam_service_name=vsftpd
dirmessage_enable=YES
xferlog_enable=YES
connect_from_port_20=YES
xferlog_std_format=YES

chroot_local_user=YES
### TLS/SSL options
### example key generation: openssl req -x509 -nodes -days 3650 -newkey rsa:2048 -keyout /etc/ssl/private/vsftpd.pem -out /etc/ssl/certs/vsftpd.pem
ssl_enable=YES
allow_anon_ssl=NO
require_ssl_reuse=YES
implicit_ssl=YES
listen_port=990
allow_writeable_chroot=YES
force_local_data_ssl=YES
force_local_logins_ssl=YES
rsa_cert_file=/etc/ssl/certs/vsftpd.pem
rsa_private_key_file=/etc/ssl/private/vsftpd.pem
ssl_tlsv1=YES
ssl_sslv2=NO
ssl_sslv3=NO
ssl_ciphers=ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA384:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA256
EOF
sudo systemctl restart vsftpd
sudo systemctl status vsftpd
