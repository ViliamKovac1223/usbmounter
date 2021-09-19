# usbmounter
Shell script to mount and unmount usb by dmenu.

# Usage
```
usbmounter -FLAG
```
- -m        mount chosen disk
- -u        unmount chosen disk
- -r        use rofi instead of dmenu

# Dependencies 
- notify-send
- dmenu or rofi

## Install dependencies on Debian
```bash
sudo apt-get install libnotify-bin suckless-tools rofi
```

## Install dependencies on Ubuntu
```bash
sudo apt-get install notify-osd dmenu rofi
```

## Install dependencies on Arch
```bash
sudo pacman -S libnotify dmenu rofi
```
