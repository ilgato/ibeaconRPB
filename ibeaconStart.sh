#!/bin/bash
clear
echo "Looking for BLE dongle..."
bt_id=`lsusb|grep ASUS|cut -c24-32`
bt_stat="0"
#check if the ASUS USB BLE is present, if not the program will end, else it checks the BLE state
if [[ -z "$bt_id" ]]; then
	echo "Bongle not found"
	exit 1
else
	bt_stat=`hciconfig|head -3|tail -1|grep UP`
	echo "found with id: "$bt_id
fi
echo $bt_stat
if [[ $bt_stat != "UP" ]]; then
	echo "Trying to enble BLE and ibeacon"
	sudo hciconfig hci0 up
	sudo hciconfig hci0 leadv 3
	sudo hciconfig hci0 noscan
	sudo hcitool -i hci0 cmd 0x08 0x0008 1E 02 01 1A 1A FF 4C 00 02 15 FB 9F C1 07 09 91 4B 43 80 84 1D 9B B2 ED EE 1A 00 00 00 00 C8
else
	echo "BLE is ready, do you want to enable an ibeacon? (y/n)"
	read iben
	if [[ $iben = "y" ]]; then
		sudo hciconfig hci0 leadv 3
		sudo hciconfig hci0 noscan
		sudo hcitool -i hci0 cmd 0x08 0x0008 1E 02 01 1A 1A FF 4C 00 02 15 FB 9F C1 07 09 91 4B 43 80 84 1D 9B B2 ED EE 1A 00 00 00 00 C8
	else
		echo "no changes were make"
	fi
fi
