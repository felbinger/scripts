# Change dm-setup / luks / cryptsetup mapper name
Change mapper name in `/etc/crypttab` (if not using lvm, also change `/etc/fstab`)
```shell
dmsetup rename sda6_crypt sys_crypt

# if the device is the boot device:
update-initramfs -c -t -k all
update-grub
reboot
```
