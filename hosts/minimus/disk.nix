{
  lib,
  disks ? ["/dev/sda"], # "/dev/vda" for VMs
  ...
}: {
  disko.devices.disk.main = {
    device = lib.mkDefault (builtins.elemAt disks 0);
    type = "disk";
    content = {
      type = "gpt";
      partitions = {
        boot = {
          name = "ESP";                    # Standard name for EFI System Partition
          size = "512M";
          type = "EF00";                   # Standard type code for EFI System Partition
          content = {
            type = "filesystem";
            format = "vfat";               # FAT32 is required for ESP
            mountpoint = "/boot";          # Standard mountpoint for ESP with systemd-boot
            mountOptions = ["umask=0077"]; # Secure mount options
          };
        };
        root = {
          name = "root";                   # root part named root
          size = "100%";                   # all remaining for root
          content = {
            type = "filesystem";
            format = "ext4";               # ext4 root FS
            mountpoint = "/";
          };
        };
      };
    };
  };
}

