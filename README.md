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
- udisks2
- dmenu or rofi

## Install dependencies on Debian
```bash
sudo apt-get install libnotify-bin suckless-tools rofi udisks2
```

## Install dependencies on Ubuntu
```bash
sudo apt-get install notify-osd dmenu rofi udisks2
```

## Install dependencies on Arch
```bash
sudo pacman -S libnotify dmenu rofi udisks2
```

# Warranty
None of the authors, contributors, administrators, or anyone else connected with this project, in any way whatsoever, can be responsible for your use of this project.
