#!/bin/sh

# privilage_provider is program that will provide you permission to use u/mount command
# privilage_provider is used because sudo shouldn't be hard-coded into the code because someone may use doas or something similar
# people who use doas or something similar may just simply change sudo to something else in this variable
privilage_provider='sudo'

mount_disk() {
  traditional=$1 # if traditional is set to true disk will mount with mount command if traditional is set to false disk will be mounted with udiscksctl
  privilage_provider=$2
  disk=$3
  mounting_point=$4

  if [ $traditional = true ]; then
    output=$(eval "$privilage_provider" mount "$disk" "$mounting_point") # mount partition

    # if there was no error make notification in syntax:
    # Mounted /dev/sdx at /path/to/mount
    # if there was error notify user about it
    [ "$output" = "" ] && notify-send "Mounted $disk at $mounting_point" || notify-send "$output"
    echo "$mounting_point" # print path to mounted disk
    [ $copy = true ] && echo "$mounting_point" | xclip -selection c # copy mounted disk path to cliboard
  else
    output=$(udisksctl mount -b "$disk") # mount partition
    notify-send "$output"
    echo "$output" | awk '{print $4}' # print path to mounted disk
    [ $copy = true ] && echo "$output" | awk '{print $4}' | xclip -selection c # copy mounted disk path to cliboard
  fi
}

umount_disk() {
  traditional=$1 # if traditional is set to true disk will unmount with umount command if traditional is set to false disk will be unmounted with udiscksctl
  privilage_provider=$2
  disk=$3

  if [ $traditional = true ]; then
    output=$(eval "$privilage_provider" umount "$disk") # mount partition

    # if there was no error make notification in syntax:
    # Unmounted /dev/sdx
    # if there was error notify user about it
    [ "$output" = "" ] && notify-send "Unmounted $disk" || notify-send "$output"
  else
    output=$(udisksctl unmount -b "$disk") # unmount disk
    notify-send "$output"
  fi
}

print_usage() {
  echo "Usage:"
  echo "usbmounter -FLAG"
  echo "-m        mount chosen disk"
  echo "-u        unmount chosen disk"
  echo "-r        use rofi instead of dmenu"
  echo "-t        use mount/umount instead of udisksctl"
  echo "-x        copy mounted disk path to cliboard"
  exit 1
}


rofi=false
traditional=false
copy=false

[ $# = 0 ] && print_usage
while getopts 'tumrx' flag; do
  case "${flag}" in
    m) mount=true ;;
    u) mount=false ;;
    r) rofi=true ;;
    t) traditional=true ;;
    x) copy=true ;;
    *) print_usage ;;
  esac
done

[ $rofi = true ] && menu="rofi -dmenu" || menu="dmenu" # define menu system

if [ $mount = true ]; then
  mountable=$(lsblk -lp | grep "part $" | awk '{print $1 " ("$4")"}') # get all not mounted partitions with their sizes
  chosen=$(echo "$mountable" | $menu -p "Mount partition " | cut -d " " -f 1) # let user choose one partition

  [ "$chosen" = "" ] && exit 1 # exit if user didn't choose any partition to mount

  mounting_point=""
  if [ $traditional = true ]; then # if traditional is set to true disk will be mounted by command mount so program will ask user where to mount a disk
    mounting_point=$(echo "" | $menu -p "Write folder where disk will be mounted ") # ask user for mounting_point
    [ "$mounting_point" = "" ] && exit # if user didn't write mounting point exit the script

    eval mounting_point="$mounting_point" # convert ~ to /home/username
    if [ ! -d "$mounting_point" ]; then # if directory doesn't exist ask user for permission to create it
      answer=$(printf "y\nn" | $menu -p "Folder doesn't exist, do you want to create it?")

      if [ "$answer" = "y" ]; then 
        mkdir -p "$mounting_point" # create a mounting_point
      else 
        exit # if user doesn't want to create folder exit the script
      fi

    fi
  fi

  mount_disk $traditional "$privilage_provider" "$chosen" "$mounting_point" "$copy" # mount disk
else
  partition_to_exclude="\(/$\|SWAP\|/home$\|/boot\)"
  unmountable=$(lsblk -lp | grep "part" | grep -v -e "part $" -e "$partition_to_exclude" | awk '{print $1 " ("$4")"}') # get all mounted partitions except /home, /boot, / and swap with their sizes

  [ "$unmountable" = "" ] && notify-send "No partition to unmount" && exit # inform user that there are no disk to unmount

  chosen=$(echo "$unmountable" | $menu -p "Unmount partition" | cut -d " " -f 1) # ask user for partition to unmount
  [ "$chosen" = "" ] && exit 1 # exit if user didn't choose any partition to unmount

  umount_disk $traditional "$privilage_provider" "$chosen" # unmount disk
fi
