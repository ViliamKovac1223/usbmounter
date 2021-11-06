# usbmounter
Shell script to mount and unmount usb by dmenu.

# Usage
```
usbmounter -FLAG
```
- -m        mount chosen disk
- -u        unmount chosen disk
- -r        use rofi instead of dmenu
- -t        use mount/umount instead of udisksctl
- -x        copy mounted disk path to cliboard

# Dependencies 
- notify-send
- udisks2 - optional [see Mount disk with traditional mount command](#Mount-disk-with-traditional-mount-command)
- dmenu or rofi
- xclip

## Install dependencies on Debian
```bash
sudo apt-get install libnotify-bin suckless-tools rofi udisks2 xclip
```

## Install dependencies on Ubuntu
```bash
sudo apt-get install notify-osd dmenu rofi udisks2 xclip
```

## Install dependencies on Arch
```bash
sudo pacman -S libnotify dmenu rofi udisks2 xclip
```

# Mount disk with traditional mount command
If you don't want to use udisks2 for mounting your drives you can use mount command.
In order to use mount command in this program you have to have permission to use command mount without a password.
For using mount without password you have to configure your sudoers file.

Open your sudoers file.
```
sudo nano /etc/sudoers
```

Add line which will grant you permission to use mount, umount without password. Change "yourgroup" to your group. Usually you want to change this to wheel group.
```
%yourgroup ALL=(ALL) NOPASSWD: /usr/bin/mount,/usr/bin/umount
```

# Doas 
If you use doas instead of sudo I believe you can make your own configuration file for running a mount without a password. Don't forget to change value of $privilage_provider to 'doas' inside of a script.
I do not provide any additional support for using a doas instead of sudo.

# Warranty
None of the authors, contributors, administrators, or anyone else connected with this project, in any way whatsoever, can be responsible for your use of this project.
