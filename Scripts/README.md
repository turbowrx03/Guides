# Installation guide for running the AQX VPS script
# Step 1
  * This will download the auto install script to your VPS.
```    
wget -q https://raw.githubusercontent.com/aquilacoin/Guides/master/Script-Files/AQX-Script.sh

```
# Step 2
  * This will mount the script 
```
bash AQX-Script.sh

```

# Step 3
  * Watch the block number until it gets to the current block height
```
watch Aquila-cli getinfo

```

# Step 4
  * Install upstart so you can use systemctl commands
```    
apt install upstart

```
# Step 5
  * These are the commands you are able to use
```    
systemctl start Aqx

systemctl status Aqx

systemctl stop Aqx

```
