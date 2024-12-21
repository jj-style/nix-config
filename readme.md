# nix-config

## channels:
- nix-channel --add https://github.com/nix-community/nixGL/archive/main.tar.gz nixgl
- nix-channel --add https://github.com/Mic92/sops-nix/archive/master.tar.gz sops-nix

## sops key for new installation
- `nix-shell -p ssh-to-age --run 'cat /etc/ssh/ssh_host_ed25519_key.pub | ssh-to-age'`
