#!/bin/bash
# This script will install all required stuff to run a OPCoinX (OPCX) Masternode.
# !! THIS SCRIPT NEED TO RUN AS ROOT !!
######################################################################

clear
echo "*********** Welcome to the OPCoinX (OPCX) Masternode Setup Script ***********"
echo 'This script will install all required updates & package for Ubuntu 14.04 !'
echo 'Clone & Compile the OPCX Wallet also help you on first setup and sync'
echo '****************************************************************************'
sleep 3
echo '*** Step 1/5 ***'
echo '*** Creating 2GB Swapfile ***'
sleep 1
dd if=/dev/zero of=/mnt/mybtdxswap.swap bs=2M count=1000
mkswap /mnt/mybtdxswap.swap
swapon /mnt/mybtdxswap.swap
sleep 1
echo '*** Done 1/5 ***'
sleep 1
echo '*** Step 2/5 ***'
echo '*** Running updates and install required packages ***'
sleep 2
sudo apt-get update -y
sudo apt-get dist-upgrade -y
sudo apt-get install automake build-essential libtool autotools-dev autoconf pkg-config libssl-dev -y
sudo apt-get install libboost-all-dev git npm nodejs nodejs-legacy libminiupnpc-dev redis-server -y
sudo apt-get install software-properties-common -y
sudo apt-get install libevent-dev -y
add-apt-repository ppa:bitcoin/bitcoin
apt-get update -y
apt-get install libdb4.8-dev libdb4.8++-dev -y
curl https://raw.githubusercontent.com/creationix/nvm/v0.16.1/install.sh | sh
source ~/.profile
echo '*** Done 2/5 ***'
sleep 1
echo '*** Step 3/5 ***'
echo '*** Cloning and Compiling OPCoinX Wallet ***'
cd
git clone https://github.com/opcoinx/OPCoinX.git
cd OPCoinX
./autogen.sh
./configure
make

cd
cd OPCoinX/src
strip opcxd
strip opcx-cli
strip opcx-tx
sudo cp opcxd /usr/local/bin
sudo cp opcx-cli /usr/local/bin
sudo cp opcx-tx /usr/local/bin
sudo /sbin/iptables -A INPUT -i eth0 -p tcp --dport 18051 -j ACCEPT
cd

echo '*** Done 3/5 ***'
sleep 2
echo '*** Step 4/5 ***'
echo '*** Configure bitcloud.conf and download and import bootstrap file ***'
sleep 2

opcxd
sleep 3

echo -n "Please Enter a STRONG Password or copy & paste the password generated for you above and Hit [ENTER]: "
read usrpas
echo -n "Please Enter your masternode genkey respond and Hit [ENTER]: "
read mngenkey

echo -e "rpcuser=btdxdmasternodeservice2387645 \nrpcpassword=$usrpas \nrpcallowip=127.0.0.1 \nserver=1 \nlisten=1 \ndaemon=1 \nlogtimestamps=1 \nmasternode=1 \npromode=1 \nmasternodeprivkey=$mngenkey \n" > ~/.OPCoinX/OPCoinX.conf

echo '*** Done 4/5 ***'
sleep 2
echo '*** Step 5/5 ***'
echo '*** Last Server Start also Wallet Sync ***'
echo 'After 1 minute you will see the 'getinfo' output from the RPC Server...'
opcxd
sleep 60
opcx-cli getinfo
sleep 2
echo 'Have fun with your Masternode !'
sleep 2
echo '*** Done 5/5 ***'