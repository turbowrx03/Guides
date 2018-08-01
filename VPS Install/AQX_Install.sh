#!/bin/bash

HEIGHT=15
WIDTH=40
CHOICE_HEIGHT=6
BACKTITLE="Aquila Masternode Setup Wizard"
TITLE="Aquila VPS Setup"
MENU="Choose one of the following options:"

OPTIONS=(1 "Install New VPS Server"
         2 "Reconfigure Existing VPS Server"
         3 "Start Aquila Masternode"
	 4 "Stop Aquila Masternode"
	 5 "Rebuild Aquila Masternode Index"
	 6 "Aquila Server Status")

CHOICE=$(whiptail --clear\
		--backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

clear
case $CHOICE in
        1)
            echo Starting the install process.
echo Checking and installing VPS server prerequisites. Please wait.
echo -e "Checking if swap space is needed."
PHYMEM=$(free -g|awk '/^Mem:/{print $2}')
SWAP=$(swapon -s)
if [[ "$PHYMEM" -lt "2" && -z "$SWAP" ]];
  then
    echo -e "${GREEN}Server is running with less than 2G of RAM, creating 2G swap file.${NC}"
    dd if=/dev/zero of=/swapfile bs=1024 count=2M
    chmod 600 /swapfile
    mkswap /swapfile
    swapon -a /swapfile
else
  echo -e "${GREEN}The server running with at least 2G of RAM, or SWAP exists.${NC}"
fi
if [[ $(lsb_release -d) != *16.04* ]]; then
  echo -e "${RED}You are not running Ubuntu 16.04. Installation is cancelled.${NC}"
  exit 1
fi

if [[ $EUID -ne 0 ]]; then
   echo -e "${RED}$0 must be run as root.${NC}"
   exit 1
fi
clear
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
clear
echo VPS Server prerequisites installed.
echo Configuring server firewall.
sudo ufw allow 45454
echo Server firewall configuration completed.
echo Downloading AquilaX install files.
wget https://github.com/aquilacoin/AquilaX/releases/download/1.2.0.0/aqx-linux.tar.gz
echo Download complete.
echo Installing AquilaX.
tar xvf aqx-linux.tar.gz
chmod 775 ./Aquilad
chmod 775 ./Aquila-cli
echo AquilaX install complete. 
rm aqx-linux.tar.gz
clear
echo Now ready to setup AquilaX configuration file.

RPCUSER=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
RPCPASSWORD=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
VPSIP=$(curl -s4 icanhazip.com)

mkdir -p /root/.Aquila && touch /root/.Aquila/Aquila.conf

cat << EOF > /root/.Aquila/Aquila.conf
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
addnode=139.99.195.25:45454
addnode=139.99.198.86:45454
addnode=139.99.194.139:45454
addnode=80.211.189.222:45454
addnode=104.207.155.156:45454
addnode=66.42.80.73:45454
addnode=104.207.155.156:45454
addnode=144.202.54.93:45454
EOF
clear
rm AQX_Install.sh
./Aquilad -daemon
sleep 30
GENKEY=$(./Aquila-cli masternode genkey)

cat << EOF >> /root/.Aquila/Aquila.conf
logtimestamps=1
maxconnections=256
masternode=1
externalip=$VPSIP
masternodeprivkey=$GENKEY
EOF

./Aquila-cli stop
./Aquilad -daemon
clear
echo AquilaX configuration file created successfully. 
echo Aquila Server Started Successfully using the command ./Aquilad -daemon
echo If you get a message asking to rebuild the database, please hit Ctr + C and run ./Aquilad -daemon -reindex
echo If you still have further issues please reach out to support in our Discord channel. 
echo Please use the following Private Key when setting up your wallet: $GENKEY
            ;;
        2)
rm Aquilad
rm Aquila-cli
rm /root/.Aquila/Aquila.conf
RPCUSER=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
RPCPASSWORD=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
VPSIP=$(curl -s4 icanhazip.com)

wget https://github.com/aquilacoin/AquilaX/releases/download/1.2.0.0/aqx-linux.tar.gz
echo Download complete.
echo Installing AquilaX.
tar xvf aqx-linux.tar.gz
chmod 775 ./Aquilad
chmod 775 ./Aquila-cli
echo AquilaX install complete. 
rm aqx-linux.tar.gz

mkdir -p /root/.Aquila && touch /root/.Aquila/Aquila.conf

cat << EOF > /root/.Aquila/Aquila.conf
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
addnode=139.99.195.25:45454
addnode=139.99.198.86:45454
addnode=139.99.194.139:45454
addnode=80.211.189.222:45454
addnode=104.207.155.156:45454
addnode=66.42.80.73:45454
addnode=104.207.155.156:45454
addnode=144.202.54.93:45454
EOF

rm AQX_Install.sh
./Aquilad -daemon
sleep 30
GENKEY=$(./Aquila-cli masternode genkey)
./Aquila-cli stop

cat << EOF >> /root/.Aquila/Aquila.conf
logtimestamps=1
maxconnections=256
masternode=1
externalip=$VPSIP
masternodeprivkey=$GENKEY
EOF
clear
./Aquilad -daemon

rm AQX_Install.sh
clear
echo AquilaX configuration file created successfully. 
echo Aquila Server Started Successfully using the command ./Aquilad -daemon
echo If you get a message asking to rebuild the database, please hit Ctr + C and run ./Aquilad -daemon -reindex
echo If you still have further issues please reach out to support in our Discord channel. 
echo Please use the following Private Key when setting up your wallet: $GENKEY
            ;;
        3)
            ./Aquilad -daemon
		echo "If you get a message asking to rebuild the database, please hit Ctr + C and rebuild Aquila Index. (Option 5)"
            ;;
	4)
            ./Aquila-cli stop
            ;;
	5)
           ./Aquilad -daemon -reindex
            ;;
        6)
	   ./Aquila-cli getinfo
	   ;;
esac
