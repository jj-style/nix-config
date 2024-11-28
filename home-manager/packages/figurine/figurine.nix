{ config, pkgs, ... }: {
  home.packages = with pkgs; [ figurine ];

  programs.bash = {
      enable = true;
      profileExtra =
        ''
        figurine -f Standard.flf `cat /etc/hostname`
        '';
  };
}
