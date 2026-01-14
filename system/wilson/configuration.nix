# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{ inputs, lib, config, pkgs , hostName, ... }:
let 
  ipAddress = "192.168.1.111";
in {
  # You can import other NixOS modules here
  imports = [
    # Import your generated (nixos-generate-config) hardware configuration
    # TODO(jj): add in
    ./hardware-configuration.nix
    ../common/nix/mynix.nix
  ];

  # TODO(jj): remove when hardware config in
  # nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  # fileSystems."/" = {
  #   device = "/dev/disk/by-uuid/3877c830-c42b-4ef4-a622-308f5ca315b3";
  #   fsType = "ext4";
  # };

  nixpkgs = {
    overlays = [
    ];
    config = {
      allowUnfree = true;
    };
  };

  nix = let flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
  in {
    settings = {
      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
      # Opinionated: disable global registry
      flake-registry = "";
      # Workaround for https://github.com/NixOS/nix/issues/9574
      nix-path = config.nix.nixPath;
    };
    # Opinionated: disable channels
    channel.enable = false;

    # Opinionated: make flake registry and nix path match flake inputs
    registry = lib.mapAttrs (_: flake: { inherit flake; }) flakeInputs;
    nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
  };

  # ========== BOOT ========== #
  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;
  boot.kernelParams = [ "quiet" "splash" "ipv6.disable=1" ];
  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
  };

  # ========== FILESYSTEM ========== #

  fileSystems = {
    "/mnt/tank" = {
        device = "/dev/disk/by-uuid/1ba9b858-ec36-45ee-a217-0f709b039ebb";
        fsType = "btrfs";
        options = ["defaults" "compress-force=zstd" "autodefrag" "noatime"];
    };

    "/mnt/storage" = {
        device = "/mnt/disk*:/mnt/tank/fuse";
        fsType = "fuse.mergerfs";
        options = ["defaults" "nonempty" "allow_other" "use_ino" "cache.files=off" "moveonenospc=true" "category.create=epmfs" "dropcacheonclose=true" "fsname=mergerfs" "minfreespace=10G"];
        depends = [
            "/mnt/tank"
            "/mnt/disk1"
        ];
    };

    "/mnt/disk1" = {
        device = "/dev/disk/by-uuid/2421d40c-9782-43de-a18a-c7a5d0192d14";
        fsType = "ext4";
    };

    "/mnt/parity1" = {
        device = "/dev/disk/by-uuid/7c4e277c-2bb7-4166-a2e3-07916032ce0e";
        fsType = "xfs";
    };
  };

  # ========== PACKAGES ========== #
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    sops
    git

    mergerfs
    mergerfs-tools
    snapraid
    btrfs-progs
    btrfs-list
    compsize
    btrbk
    xfsprogs
  ];

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "gb";
    variant = "";
  };
  # Configure console keymap
  console.keyMap = "uk";

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # ========== USERS ========== #
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users = {
    mutableUsers = false;
    users.jj = {
      isNormalUser = true;
      extraGroups = [ "networkmanager" "wheel" "docker" ];
      packages = with pkgs; [ ];
      hashedPasswordFile = "${config.sops.secrets.passwd.path}";
    };
  };

  security.sudo = {
    enable = true;
    extraRules = [{
      commands = [];
      groups = [ "wheel" ];
    }];
  };

  # ========== SOPS ========== #
  sops = {
    defaultSopsFile = ../../secrets/${hostName}.yaml;
    validateSopsFiles = false;
    # This will automatically import SSH keys as age keys
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    # This is using an age key that is expected to already be in the filesystem
    #age.keyFile = "/var/lib/sops-nix/key.txt";
    # This will generate a new key if the key specified above does not exist
    #age.generateKey = false;
    secrets = {
      "passwd" = {
        neededForUsers = true;
      };
      "tailscale_authkey" = {};
      "wireguard/ip" = {};
      "wireguard/private" = {};
      "wireguard/server/public" = {};
      "wireguard/server/endpoint" = {};
    };
  };

  # ========== NETWORK ========== #
  networking.hostName = hostName; # Define your hostname.
  # Enable networking
  networking.networkmanager.enable = true;
  systemd.services.NetworkManager-wait-online.enable = false;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 22 ];
  networking.firewall.allowedUDPPorts = [ 51820 ];
  networking.firewall.trustedInterfaces = [ "tailscale0" "wg0" ];
  # Or disable the firewall altogether.
  networking.firewall.enable = true;
  networking.firewall.allowPing = true;

  networking.enableIPv6 = false;

  networking.interfaces.eth0 = {
    ipv4.addresses = [{address = ipAddress; prefixLength = 24;}];
  };
  networking.defaultGateway = {
    address = "192.168.1.1";
    interface = "eth0";
  };

  networking.wg-quick.interfaces.wg0.configFile = "${config.sops.templates."wg0.conf".path}";
  sops.templates."wg0.conf".content = ''
    [Interface]
    Address = ${config.sops.placeholder."wireguard/ip"}
    PrivateKey = ${config.sops.placeholder."wireguard/private"}
    PostUp = ${pkgs.iptables}/bin/iptables -A FORWARD -i wg0 -j ACCEPT; ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.2.0.1/24 -o eth0 -j MASQUERADE
    PostDown = ${pkgs.iptables}/bin/iptables -D FORWARD -i wg0 -j ACCEPT; ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.2.0.1/24 -o eth0 -j MASQUERADE

    [Peer]
    PublicKey = ${config.sops.placeholder."wireguard/server/public"}
    AllowedIps = 10.2.0.0/24
    Endpoint = ${config.sops.placeholder."wireguard/server/endpoint"}
    PersistentKeepAlive = 25
  '';

  virtualisation.docker = {
    enable = true;
  };

  # ========== SERVICES ========== #
  services.openssh = {
    enable = true;
    settings = {
      # Opinionated: forbid root login through SSH.
      PermitRootLogin = "no";
      # Opinionated: use keys only.
      # Remove if you want to SSH using passwords
      PasswordAuthentication = false;
    };
  };

  services.avahi = {
    enable = true;
    nssmdns4 = true;
  };

  services.tailscale = {
    enable = true;
    openFirewall = true;
    authKeyFile = "${config.sops.secrets."tailscale_authkey".path}";
    useRoutingFeatures = "client";
    extraUpFlags = ["--ssh" "--advertise-exit-node --accept-dns=false"];
  };

  services.smartd = {
    enable = false;
    devices = [
      {
        #device = "/dev/disk/by-id/ata-WDC-XXXXXX-XXXXXX"; # FIXME: Change this to your actual disk
      }
    ];
  };

  services.btrfs.autoScrub.enable = true;
  services.btrfs.autoScrub.interval = "monthly";

  # TODO - curl healthcheck after btrbk
  services.btrbk = {
    # https://nixos.wiki/wiki/Btrbk
    instances."tank" = {
        onCalendar = "daily";
        settings = {
            stream_compress = "lz4";
            snapshot_preserve_min = "1w";
            snapshot_preserve = "2w";
            target_preserve_min = "no";
            target_preserve =  "20d 10w *m";
            snapshot_dir = ".snapshots";
            volume."/mnt/tank" = {
                target = "ssh://snowy/mnt/backups";
                subvolume = {
                    "fuse" = {};
                    "documents" = {};
                };
            };
        };
    };
  };
  #TODO: not sure this is needed??
  #systemd.tmpfiles.rules = [
    #"d /mnt/tank/.snapshots 0755 root root"
  #];

  services.samba = {
    # https://nixos.wiki/wiki/Samba
    enable = true;
    openFirewall = true;
    settings = {
        global = {
            "workgroup" = "WORKGROUP";
            "server string" = hostName;
            "security" = "user";
            "map to guest" = "bad password"; 
            "guest ok" = "yes";
            "guest account" = "nobody";
            #"hosts allow" = "192.168.0. 127.0.0.1 localhost";
            #"hosts deny" = "0.0.0.0/0";
            #"load printers" = "no";
            #"printcap name" = "/dev/null";
        };
        storage = {
            "path" = "/mnt/storage";
            "browseable" = "yes";
            "guest ok" = "no";
            "read only" = "no";
            "create mask" = "0644";
            "directory mask" = "0755";
        };
    };
  };

  # TODO: curl healthcheck after snapraid 
  services.snapraid = {
    enable = true;
    parityFiles = [
        "/mnt/parity1/snapraid.parity"
    ];
    contentFiles = [
        "/var/snapraid.content"
        "/mnt/disk1/.snapraid.content"
    ];
    dataDisks = {
        d1 = "/mnt/disk1";
    };
    exclude = [
        "*.unrecoverable"
        "/tmp/"
        "/lost+found/"
        "downloads/"
        "appdata/"
        "*.!sync"
        ".AppleDouble"
        "._AppleDouble"
        ".DS_Store"
        "._.DS_Store"
        ".Thumbs.db"
        ".fseventsd"
        ".Spotlight-V100"
        ".TemporaryItems"
        ".Trashes"
        ".AppleDB"
        ".nfo"
        ".minio.sys/"
        "/.snapshots/"
    ];
    touchBeforeSync = true;
    sync = {
        interval = "daily";
    };
    scrub = {
        interval = "weekly";
        plan = 22;
        olderThan = 8;

    };
  };

  services.minidlna = {
    enable = true;
    openFirewall = true;
    settings = {
      # port=8201;
      friendly_name = config.networking.hostName;
      inotify = "yes";
      media_dir = [
        "A,/mnt/storage/music/main"
        "V,/mnt/storage/videos/movies"
        "P,/mnt/storage/photos"
      ];
      album_art_names = [
        "Cover.jpg/cover.jpg/cover.jpeg/AlbumArtSmall.jpg/albumartsmall.jpg"
        "AlbumArt.jpg/albumart.jpg/Album.jpg/album.jpg"
        "Folder.jpg/folder.jpg/Thumb.jpg/thumb.jpg"
      ];
    };
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.05";
}
