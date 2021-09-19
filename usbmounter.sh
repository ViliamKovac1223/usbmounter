#!/bin/sh

mountable=$(lsblk -lp | grep "part $" | awk '{print $1 " ("$4")"}') # get all not mounted partitions with their sizes
chosen=$(echo "$mountable" | dmenu -p "Mount partition: " | cut -d " " -f 1) # let user choose one partition by dmenu

[ "$chosen" = "" ] && exit 1 # exit if user didn't choose any partition to mount

output=$(udisksctl mount -b "$chosen") # mount partition
notify-send "$output"
