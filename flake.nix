{
  description = "Run Fava as SystemD service";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }: {
    nixosModules.default = import ./module.nix self;

    nixosConfigurations.container = import ./container.nix {
      inherit self nixpkgs;
    };
  };
}
