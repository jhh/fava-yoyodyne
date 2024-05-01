self: { config, lib, pkgs, ... }:
let
  cfg = config.j3ff.services.fava-yoydyne;
in
{
  options.j3ff.services.fava-yoydyne = {
    enable = lib.mkEnableOption "Enable the Yoydyne Fava Beancount service";
  };

  config = lib.mkIf cfg.enable {
    systemd.services."fava-yoydyne" = {
      wantedBy = [ "multi-user.target" ];

      preStart = ''
        LEDGER="$STATE_DIRECTORY/ledger.beancount"
        DOCS="$STATE_DIRECTORY/docs"
        if [[ ! -f $LEDGER ]]; then
          echo $LEDGER does not exist, creating...

          cat <<- EOF > $LEDGER
        option "title" "Yoydyne Expenses"
        option "operating_currency" "USD"
        option "documents" "$DOCS"
        EOF

          mkdir $DOCS
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
        StateDirectory = "fava-yoydyne";
        Restart = "on-failure";
      };
    };

    services.nginx = {
      enable = true;
      recommendedProxySettings = true;
      recommendedOptimisation = true;
      recommendedGzipSettings = true;


      virtualHosts."fava.j3ff.io" = {
        locations = {
          "/" = {
            proxyPass = "http://127.0.0.1:5000";
          };
        };
        serverAliases = [ "yoydyne.j3ff.io" ];
      };
    };
  };
}
