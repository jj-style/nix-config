{ config, pkgs, ... }: {
  programs.bash = {
    enable = true;
    enableCompletion = true;
    bashrcExtra = ''
      function dy { dig +noall +answer +additional "$1" @dns.toys; }
    '';
  };
}
