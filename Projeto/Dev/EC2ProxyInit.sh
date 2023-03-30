#!/bin/bash
sudo apt update
sudo apt install nginx -y
sudo apt install awscli -y
cd /etc/nginx
sudo rm nginx.conf
sudo aws s3 cp s3://opus-matheus-silva-webapp/nginx.conf nginx.conf
sudo systemctl restart nginx