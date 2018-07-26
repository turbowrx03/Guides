#!/usr/bin/env bash
echo Starting the install process.
echo Checking and installing VPS server prerequisites. Please wait.
sudo apt update
sudo apt-get -y upgrade
sudo apt-get install git -y
sudo apt-get install build-essential libtool autotools-dev automake pkg-config libssl-dev libevent-dev bsdmainutils -y
sudo apt-get install libboost-system-dev libboost-filesystem-dev libboost-chrono-dev libboost-program-options-dev libboost-test-dev libboost-thread-dev -y
sudo apt-get install libboost-all-dev -y
sudo apt-get install software-properties-common -y
sudo add-apt-repository ppa:bitcoin/bitcoin -y
sudo apt-get update
sudo apt-get install libdb4.8-dev libdb4.8++-dev -y
sudo apt-get install libminiupnpc-dev -y
sudo apt-get install libzmq3-dev -y
sudo apt-get install libqt5gui5 libqt5core5a libqt5dbus5 qttools5-dev qttools5-dev-tools libprotobuf-dev protobuf-compiler -y
sudo apt-get install libqt4-dev libprotobuf-dev protobuf-compiler -y

echo VPS Server prerequisites installed.
echo Configuring server firewall.
sudo ufw allow 45454
echo Server firewall configuration completed.
echo Downloading AquilaX install files.
wget https://github.com/aquilacoin/Aquila/releases/download/1.1.0.5/ubuntu.zip
echo Download complete.
echo Installing AquilaX.
apt install unzip
unzip ubuntu.zip
chmod 775 ./Aquilad
chmod 775 ./Aquila-cli
echo AquilaX install complete. 

echo Now ready to setup AquilaX configuration file.

echo Please input the RPC Username.
read RPCUSER
echo Please input the RPC Password.
read RPCPASSWORD
VPSIP=NODEIP=$(curl -s4 icanhazip.com)
echo Please input the private key.
read GENKEY

mkdir -p /root/.Aquila && touch /root/.Aquila/Aquila.conf

cat > /root/.Aquila/Aquila.conf << EOF
rpcuser=$RPCUSER
rpcpassword=$RPCPASSWORD
rpcallowip=127.0.0.1
server=1
listen=1
daemon=1
staking=1
rpcallowip=127.0.0.1
rpcport=45455
port=45454
logtimestamps=1
maxconnections=256
masternode=1
externalip=$VPSIP
masternodeprivkey=$GENKEY
addnode=139.99.195.25:45454
addnode=139.99.198.86:45454
addnode=139.99.194.139:45454
addnode=80.211.189.222:45454
addnode=104.207.155.156:45454
addnode=66.42.80.73:45454
addnode=104.207.155.156:45454
addnode=144.202.54.93:45454
EOF

echo AquilaX configuration file created successfully. 
echo Please start your new AquilaX masternode by running ./Aquilad -daemon
echo If you get a message asking to rebuild the database, please hit Ctr + C and run ./Aquilad -daemon -reindex
echo If you still have further issues please reach out to support in our Discord channel. 
