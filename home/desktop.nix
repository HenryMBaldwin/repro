{ config, pkgs, lib, ... }:

{
  home.packages = [ pkgs.warpd ];

  launchd.agents.warpd = {
    enable = true;
    config = {
      ProgramArguments = [ "${lib.getExe pkgs.warpd}" "-f" ];
      RunAtLoad = true;
      KeepAlive = true;
      ProcessType = "Interactive";
    };
  };

  systemd.user.services.warpd = {
    Unit = {
      Description = "warpd";
      PartOf = [ "graphical-session.target" ];
    };
    Install.WantedBy = [ "graphical-session.target" ];
    Service = {
      ExecStart = "${lib.getExe pkgs.warpd} -f";
      Restart = "on-failure";
    };
  };
}
