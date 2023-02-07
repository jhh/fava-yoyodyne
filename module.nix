self: { config, lib, pkgs, ... }:
let
  cfg = config.j3ff.services.fava-gencon;
in
{
  options.j3ff.services.fava-gencon = {
    enable = lib.mkEnableOption "Enable the Gencon Fava Beancount service";
  };

  config = lib.mkIf cfg.enable {
    systemd.services."fava-gencon" = {
      wantedBy = [ "multi-user.target" ];

      preStart = ''
        LEDGER="$STATE_DIRECTORY/ledger.beancount"
        if [[ ! -f $LEDGER ]]; then
          echo $LEDGER does not exist, creating...
          touch $LEDGER
        else
          echo $LEDGER already exists
        fi
      '';

      script = ''
        LEDGER="$STATE_DIRECTORY/ledger.beancount"
        ${pkgs.fava}/bin/fava $LEDGER
      '';

      serviceConfig = {
        DynamicUser = true;
        StateDirectory = "fava-gencon";
        Restart = "on-failure";
      };
    };

    services.nginx = {
      enable = true;
      recommendedProxySettings = true;
      recommendedOptimisation = true;
      recommendedGzipSettings = true;


      virtualHosts."gencon.j3ff.io" = {
        locations = {
          "/" = {
            proxyPass = "http://127.0.0.1:5000";
          };
        };
      };
    };
  };
}
