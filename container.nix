{ self, nixpkgs }:
let
  system = "x86_64-linux";
in
nixpkgs.lib.nixosSystem {
  inherit system;
  modules = [
    self.nixosModules.default
    ({ ... }: {
      boot.isContainer = true;
      networking.useDHCP = false;
      networking.firewall.enable = false;
      j3ff.services.fava-gencon = {
        enable = true;
      };
      system.stateVersion = "23.05";
    })
  ];
}
