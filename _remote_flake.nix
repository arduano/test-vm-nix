{
  description = "NixOS base for jetson testing";

  inputs = {
    base.url = "github:arduano/test-vm-nix/master";
  };

  outputs = { self, base, ... }@inputs:
    {
      nixosConfigurations.dev-vm = base.config;
    };
}
