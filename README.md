# usbmounter
Shell script to mount and unmount usb by dmenu.

# Usage
```
usbmounter -FLAG
```
- -m        mount chosen disk
- -u        unmount chosen disk

# Dependencies 
- notify-send
- dmenu 

## Install dependencies on Debian
```bash
sudo apt-get install libnotify-bin suckless-tools
```

## Install dependencies on Ubuntu
```bash
sudo apt-get install notify-osd dmenu
```

## Install dependencies on Arch
```bash
sudo pacman -S libnotify dmenu
```
