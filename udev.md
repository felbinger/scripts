You can hide partitions (e. g. the Windows Boot Partition) from your file manager using a simple udev rule:
1. Get the uuid of the partition:
    ```shell
    udevadm info --query=all -n /dev/sdd2`
    ```
3. Create `/etc/udev/rules.d/99-hide-disks.rules`:
    ```shell
    ENV{ID_PART_ENTRY_UUID}=="49081a07-a284-49aa-b6ac-dddbd8537e9b", ENV{UDISKS_IGNORE}="1"
    ```
3. Test it
    ```shell
    sudo udevadm control --reload-rules && sudo udevadm trigger
    ```
