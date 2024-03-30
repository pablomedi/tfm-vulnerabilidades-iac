#!/bin/bash
sudo apt update
echo '* libraries/restart-without-asking boolean true' | sudo debconf-set-selections
sudo apt install -y nmap
sudo apt install -y metasploit-framework
sudo apt install -y wordlists
sudo apt install -y john
sudo apt install -y hydra
sudo apt install -y hashcat
sudo apt install -y sqlmap
sudo apt-install -y vim
sudo apt install -y curl