{ config, pkgs, ... }: {
  home.packages = with pkgs; [
    git
    gum
    convco
    gitui
  ];

  sops = {
    secrets = {
      "git/name" = {};
      "git/email" = {};
    };
    templates = {
      "git_user_config_ini".content = ''
        [user]
            name = ${config.sops.placeholder."git/name"}
            email = ${config.sops.placeholder."git/email"}
      '';
    };
  };

  programs.git = {
    enable = true;
    includes = [{path="${config.sops.templates."git_user_config_ini".path}";}];
    delta = {
      enable = true;
      options = {
        # use n and N to move between diff sections
        navigate = true;
        # or light = true, or omit for auto-detection
        dark = true;
      };
    };
    ignores = [ "*~" "*.swp" ];
    aliases = {
      cc = "cc = !convco commit";
      co = "!git checkout $(git branch | gum filter -- placeholder \"branch...\")";
      gadd = "!git add $(git ls-files -m --others --exclude-standard | gum choose --no-limit)";
      curr = "!git rev-parse --abbrev-ref HEAD";
      prunelist = "!git branch -vv | grep 'gone]' | awk '{print $1}'";
    };
    extraConfig = {
      init = { defaultBranch = "master"; };
      url."ssh://aur@aur.archlinux.org".insteadOf = "https://aur.archlinux.org";
    };
  };
}
