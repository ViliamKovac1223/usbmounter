#!/bin/sh

print_usage() {
  echo "Usage:"
  echo "usbmounter -FLAG"
  echo "-m        mount chosen disk"
  echo "-u        unmount chosen disk"
  echo "-r        use rofi instead of dmenu"
  exit 1
}

rofi=false

[ $# = 0 ] && print_usage
while getopts 'umr' flag; do
  case "${flag}" in
    m) mount=true ;;
    u) mount=false ;;
    r) rofi=true ;;
    *) print_usage ;;
  esac
done

[ $rofi = true ] && menu="rofi -dmenu" || menu="dmenu" # define menu system

if [ $mount = true ]; then
  mountable=$(lsblk -lp | grep "part $" | awk '{print $1 " ("$4")"}') # get all not mounted partitions with their sizes
  chosen=$(echo "$mountable" | $menu -p "Mount partition " | cut -d " " -f 1) # let user choose one partition

  [ "$chosen" = "" ] && exit 1 # exit if user didn't choose any partition to mount

  output=$(udisksctl mount -b "$chosen") # mount partition
  notify-send "$output"
else
  partition_to_exclude="\(/$\|SWAP\|/home\|/boot\)"
  unmountable=$(lsblk -lp | grep "part" | grep -v -e "part $" -e "$partition_to_exclude" | awk '{print $1 " ("$4")"}') # get all mounted partitions except /home, /boot, / and swap with their sizes

  [ "$unmountable" = "" ] && notify-send "No partition to unmount" && exit

  chosen=$(echo "$unmountable" | $menu -p "Unmount partition" | cut -d " " -f 1) # ask user for partition to unmount
  [ "$chosen" = "" ] && exit 1 # exit if user didn't choose any partition to unmount

  output=$(udisksctl unmount -b "$chosen") # unmount disk
  notify-send "$output"
fi
