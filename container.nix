{ self, nixpkgs }:
let
  system = "x86_64-linux";
in
nixpkgs.lib.nixosSystem {
  inherit system;
  modules = [
    self.nixosModules.default
    ({ ... }: {
      j3ff.services.fava-gencon.enable = true;
      services.sshd.enable = true;
      networking.firewall.allowedTCPPorts = [ 80 ];
      services.openssh.permitRootLogin = "yes";
      services.getty.autologinUser = "root";
      services.tailscale.enable = true;
      system.stateVersion = "23.05";
    })
  ];
}
