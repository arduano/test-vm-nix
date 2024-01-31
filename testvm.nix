{ config, lib, pkgs, ... }:

{
  networking.hostName = "testvm";

  fileSystems."/dummynix/nix" =
    {
      device = "rootpool/dummynix";
      fsType = "zfs";
    };
}
