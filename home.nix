{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "gasdia73";
  home.homeDirectory = "/home/gasdia73";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  programs.git = {
    enable = true;
    userName = "Roberto Gasdia";
    userEmail = "gasdia73@gmail.com";
    extraConfig = {
      init.defaultBranch = "main";
    };
  };

  fonts.fontconfig.enable = true;
  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello
    pkgs.kcalc
    # pkgs.dbeaver-bin
    pkgs.starship
    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })
    (pkgs.nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
    pkgs.xorg.xev
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/gasdia73/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
    GDK_CORE_DEVICE_EVENTS=1;
    NIXOS_OZONE_WL = "1";
  };

  programs.bash = {
    enable = true;
    shellAliases = {
      dir = "ls -al --color=auto";
      ".." = "cd ..";
      dc = "docker compose";
    };
    historyControl = ["ignoredups"];
    bashrcExtra = ''
      eval "$(starship init bash)"
      eval "$(direnv hook bash)"
      export JAVA_HOME=$(readlink -e $(type -p javac) | sed  -e 's/\/bin\/javac//g')
      export LD_LIBRARY_PATH=$(nix build --print-out-paths --no-link nixpkgs#libGL)/lib
    '';   
  };

  programs.starship = {
    enable = true;
    # settings = pkgs.lib.importTOML ./starship/starship.toml;
    settings = pkgs.lib.importTOML ./starship/pastel.toml;
  };

  xsession = {
    enable = true;
    numlock.enable = true;
    initExtra = ''
      xinput --set-prop 14 "libinput Accel Profile Enabled" 1 0 
      xinput --set-prop 14 "libinput Accel Speed" 0.9 
      xinput --set-prop 14 'Coordinate Transformation Matrix' 0.1 0 0 0 0.1 0 0 0 0.1 
      xinput --set-prop 12 "libinput Accel Profile Enabled" 1 0 
      xinput --set-prop 12 "libinput Accel Speed" 0.9 
      xinput --set-prop 12 'Coordinate Transformation Matrix' 0.1 0 0 0 0.1 0 0 0 0.1    
      xinput --set-prop 11 "libinput Accel Profile Enabled" 1 0 
      xinput --set-prop 11 "libinput Accel Speed" 0.9 
      xinput --set-prop 11 'Coordinate Transformation Matrix' 0.1 0 0 0 0.1 0 0 0 0.1      
    '';   
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
