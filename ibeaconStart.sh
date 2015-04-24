#!/bin/bash
#/////////////////////////////////////////////////////////////////////////////////////////
# This program generates an Ibeacon readable by any capable device, it is also capable
# to generate a generic beacon (will not be seen by apple produ)
#
#/////////////////////////////////////////////////////////////////////////////////////////

#this function receives if th dongle is pluged and its state
function headr
{
	clear
	local st1="$1"
	local st2="$2"
	echo "BLE-iBeacon enabler for RBP V 1.0"
	echo "__________________________________________________________________________________"
	echo "Bluetooth: ${st1} State: ${st2}"
	echo "__________________________________________________________________________________"
}
#This function sends a custom beacon, it receives two parameters, the first tell is it is a 
#custom iBecon or beacon and the second is the value of the packet
function BLEchain
{
	echo "Please insert a custom UUID to be transmited (16 bytes separated by a space inbetween, like:"
	echo "00 01 02 03 04 05 06 07 08 09 0A 0B 0C 0D 0E 0F"
	read uid
	uidsize=${#uid}
	if [[ $uidsize = 47 ]]; then
	local p1="0x08 0x0008 1E 02 01 1A 1A FF 4C 00 02 15 "
	local p2=" 00 00 00 00 C8"
	sudo hcitool -i hci0 cmd $p1 $uid $p2
	else
		echo "wrong input, please try again"
		echo "press a key to continue..."
		read qwe
		headr $bt_pres $bt_stat
		BLEchain ib
	fi
}
function helpI
{
	headr $bt_pres $bt_stat
	echo "Select on of the options from the menu:"
	echo "1. If possible, the program will start sending a default iBeacon with UUID:"
	echo "FB 9F C1 07 09 91 4B 43 80 84 1D 9B B2 ED EE 1A"
	echo "2. An iBeacon will start being advertized but with an user defined UUID, please"
	echo "use the correct format, 16 bytes separated by a single space."
	echo "3. Still not functional, for now it just do the same as 2."
	echo "4. sets the bluetooth state to UP."
	echo "5. Sets the bluetooth state to DOWN, notice that in most cases the beacon will."
	echo "remain active even if the bluetooth state is set to DOWN."
	echo ""
	echo "Press a key to go back to the menu"
}
function menu
{
	echo "1. send default iBeacon"
	echo "2. send custom iBeacon"
	echo "3. send custom Beacon"
	echo "4. set BT state to UP"
	echo "5. set BT state to DOWN"
	echo "6. Help"
	echo "7. Exit"
	read opt
	case $opt in
		1)
		headr $bt_pres $bt_stat
		echo "IBeacon activation..."
		sudo hcitool -i hci0 cmd 0x08 0x0008 1E 02 01 1A 1A FF 4C 00 02 15 FB 9F C1 07 09 91 4B 43 80 84 1D 9B B2 ED EE 1A 00 00 00 00 C8
		echo "press a key to continue..."
		read qwe
		headr $bt_pres $bt_stat
		menu
		;;
		2)
		headr $bt_pres $bt_stat
		BLEchain ib
		echo "press a key to continue..."
		read qwe
		headr $bt_pres $bt_stat
		menu
		;;
		3)
		headr $bt_pres $bt_stat
		BLEchain b
		echo "press a key to continue..."
		read qwe
		headr $bt_pres $bt_stat
		menu
		;;
		4)
		sudo hciconfig hci0 up
		sudo hciconfig hci0 leadv 3
		sudo hciconfig hci0 noscan
		bt_stat=`hciconfig|head -3|tail -1|grep "UP\|DOWN"`
		echo "press a key to continue..."
		read qwe
		headr $bt_pres $bt_stat
		menu
		;;
		5)
		sudo hciconfig hci0 down
		bt_stat=`hciconfig|head -3|tail -1|grep "UP\|DOWN"`
		echo "press a key to continue..."
		read qwe
		headr $bt_pres $bt_stat
		menu
		;;
		6)
		helpI
		echo "press a key to continue..."
		read qwe
		headr $bt_pres $bt_stat
		menu
		;;
		7)
		exit 0
		;;
		*)
		echo "Please select from 1 to 6"
		echo "press a key to continue..."
		read qwe
		headr $bt_pres $bt_stat
		menu
		;;
	esac
}
#/////////////////////////////////////////////////////////////////////////////////////////
bt_id=""
bt_pres="-"
bt_stat="-"
headr $bt_pres $bt_stat
echo "Looking for BLE dongle..."
bt_id=`lsusb|grep ASUS|cut -c24-32`

#check if the ASUS USB BLE is present, if not the program will end, else it checks the BLE state
if [[ -z "$bt_id" ]]; then
	bt_pres="not found"
	headr $bt_pres $bt_stat
	echo "Bongle not found, press a key to exit..."
	read qwe
	exit 1
else
	bt_pres="OK"
	bt_stat=`hciconfig|head -3|tail -1|grep "UP\|DOWN"`
	headr $bt_pres $bt_stat
	menu
fi

