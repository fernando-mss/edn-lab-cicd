#!/bin/bash
sudo chown -R ec2-user:ec2-user /home/ec2-user/app
echo "[DEBUG] install_dependencies.sh executado como: $(whoami)" >> /home/ec2-user/app/deploy.log
mkdir -p /home/ec2-user/app
cd /home/ec2-user/app || exit 1
echo "Instalando dependências..."
sudo yum update -y
sudo yum install -y python3-pip
pip3 install -r requirements.txt