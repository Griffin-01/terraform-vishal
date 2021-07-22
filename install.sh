#!/bin/bash
sudo apt-get -y update 

echo "golang install"
wget https://dl.google.com/go/go1.13.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go1.13.linux-amd64.tar.gz && export PATH=$PATH:/usr/local/go/bin && export PATH=$PATH:/home/ubuntu/go/bin
source ~/.profile


echo "Installing asset finder"
go get -u github.com/tomnomnom/assetfinder
echo "done"

echo "Installing subfinder"
GO111MODULE=on go get -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder
echo "done"

sudo snap install amass