{ config, lib, ... }:

# https://stackoverflow.com/a/38635298

with lib;

let
  cfg = config.services.create-run-postgresql;
in {
  options = {
    services.create-run-postgresql = { 
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to enable create-run-postgresql.";
      };
      path = mkOption {
        type = types.path;
        default = "/run/postgresql";
        description = "The path of the directory to create";
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.create-run-postgresql = {
      wantedBy = [ "multi-user.target" ];
      after = [ "local-fs.target" ];
      serviceConfig.Type = "oneshot";
      serviceConfig.RemainAfterExit = true;
      serviceConfig.StandardOutput = "journal";
      preStart = ''
        mkdir -p "${cfg.path}"
        chown vagrant:vagrant ${cfg.path}
      '';
      serviceConfig.ExecStart = "/usr/bin/env true";
    };
  };
}
