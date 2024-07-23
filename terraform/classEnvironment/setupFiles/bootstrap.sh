#!/bin/bash

# Set non-interactive mode
export DEBIAN_FRONTEND=noninteractive

# no interactive prompts
sed -i "s/#\$nrconf{restart} = 'i';/\$nrconf{restart} = 'a';/" /etc/needrestart/needrestart.conf

echo "Start bootstrap script"
sudo apt-get update -y
sudo apt-get install -y net-tools python3 python3-pip unzip

# Golang 1.22 install
echo "Installing Golang 1.22"
sudo wget https://go.dev/dl/go1.22.0.linux-amd64.tar.gz
sudo tar -C /usr/local/ -xvf go1.22.0.linux-amd64.tar.gz  
echo "export GOROOT=/usr/local/go" >> /home/ubuntu/.profile
echo "export GOPATH=\$HOME/go" >> /home/ubuntu/.profile 
echo "export PATH=\$PATH:/usr/local/go/bin" >> /home/ubuntu/.profile

# Caldera install
echo "Installing Caldera"
echo "Installing some packages for Caldera"
sudo adduser --system --group caldera
sudo apt-get install -y apt-transport-https ca-certificates gnupg2 software-properties-common upx python3.9 python3-pip
sudo pip3 install --upgrade pyOpenSSL

# Install NodeJS for Caldera 5.0 requirement
cd ~
curl -fsSL https://deb.nodesource.com/setup_21.x | sudo -E bash -
sudo apt-get install -y nodejs

# Downloading Caldera
echo "Downloading Caldera"
cd /opt
sudo git clone https://github.com/mitre/caldera.git --recursive

# Copy Caldera Service and local.yml
cd /opt/caldera
sudo pip3 install -r requirements.txt
sudo cp /home/ubuntu/setupFiles/caldera.service /etc/systemd/system/caldera.service
sudo cp /home/ubuntu/setupFiles/local.yml /opt/caldera/conf/local.yml
sudo unzip /home/ubuntu/setupFiles/abilities.zip -d /opt/caldera/data/abilities/
sudo unzip /home/ubuntu/setupFiles/payloads.zip -d /opt/caldera/data/payloads/

# Caldera SSL setup
echo "Modifying caldera configuration files"
IP_ADDRESS=$(hostname -I | awk '{print $1}')
export IP_ADDRESS
sed -i "s|http://0.0.0.0:8888|http://$IP_ADDRESS:8888|" conf/local.yml
sed -i "s|host: 0.0.0.0|host: $IP_ADDRESS|" conf/local.yml

sudo chown -R caldera:caldera /opt/caldera
sudo chmod 644 /etc/systemd/system/caldera.service
sudo systemctl daemon-reload
sudo systemctl enable caldera
sudo systemctl start caldera