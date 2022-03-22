{ config, pkgs, ... }:

{
  # Enabling unfree packages, adding unstable channel to be able to install latest packages as user
  environment.interactiveShellInit = ''
    if [ ! -f ~/.bashrc ]
      then
        echo 'eval "$(direnv hook bash)"' > ~/.bashrc
    fi

    if [ ! -f ~/.config/direnv/direnv.toml ]
      then
        mkdir -p ~/.config/direnv
        echo -e '[whitelist]\nprefix = [ "/home/vagrant/systematic_review" ]' > ~/.config/direnv/direnv.toml
    fi

    if [ ! -f ~/.config/nixpkgs/config.nix ]
      then
        mkdir -p ~/.config/nixpkgs/
        echo '{ allowUnfree = true; }' > ~/.config/nixpkgs/config.nix
    fi
  '';

  networking.firewall.enable = false;

  nix = {
    autoOptimiseStore = true;
    extraOptions = ''
      keep-derivations = true
      keep-outputs = true
    '';
  };

  virtualisation = {
    podman = {
      enable = true;

      # Create a `docker` alias for podman, to use it as a drop-in replacement
      dockerCompat = true;
    };
  };
}
