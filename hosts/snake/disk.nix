{
  lib,
  disks ? ["/dev/sda"],
  ...
}: {
  disko.devices = {
    disk = {
      main = {
        device = lib.mkDefault (builtins.elemAt disks 0);
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            boot = {
              size = "1G";
              priority = 1;
              type = "EF00"; # EFI System Partition type
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = ["umask=0077"];
              };
            };
            root = {
              size = "100%";
              priority = 2;
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
              };
            };
          };
        };
      };
    };
  };
}
