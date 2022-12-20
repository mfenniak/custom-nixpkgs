{ config, lib, pkgs, options }:

with lib;

let
  cfg = config.services.prometheus-custom.exporters.podman;
in
{
  port = 9882;
  serviceOpts = {
    serviceConfig = {
      DynamicUser = false;
      StateDirectory = "prometheus-podman-exporter";
      WorkingDirectory = "/var/lib/prometheus-podman-exporter";
      # ProtectHome = lib.mkForce "tmpfs";
      # WorkingDirectory = "$RUNTIME_DIRECTORY";
      # RuntimeDirectory = "prometheus-podman-exporter";
      # StateDirectory = "prometheus-podman-exporter";
      ExecStart = ''
        ${pkgs.prometheus-podman-exporter}/bin/prometheus-podman-exporter \
          --web.listen-address ${cfg.listenAddress}:${toString cfg.port} \
          ${concatStringsSep " \\\n  " cfg.extraFlags}
      '';
    };
  };
}
