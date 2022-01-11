{ config, lib, pkgs }:
with lib;
let
  cfg = config.tmux;

  # defaults
  defaults = {
    keyMode = "emacs";
    resize = 10;
    shortcut = "Space";
    terminal = "screen-256color";
    shell = null;
  };

  config = ''
    ${optionalString cfg.sensible.enable  ''
      ##########################################
      #           Sensible defaults            #
      ##########################################
      run-shell TODO
      ##########################################
    ''}
    set -g default-terminal ${cfg.terminal}
    set -g base-index ${cfg.baseIndex}
    setw -g base-pane-index ${toString cfg.baseIndex}
    ${optionalString (cfg.shell != null) ''
      set -g default-shell "${cfg.shell}"
    ''}
    set -g status-keys ${cfg.keyMode}
    set -g mode-keys ${cfg.keyMode}
  '';
  
in {
  options = {
    programs.tmux = {
      # enable module
      enable = mkEnableOption "tmux";

      # prefix
      shortcut = mkOption {
        default = null;
        example = "C-space";
        type = types.str;
        description = "Set the shortcut key (CTRL+?)";
      };

      # session manager
      sessionManager = mkOption {
        default = null;
        example = "tmuxp";
        type = types.enum [ "smug" "teamocil" "tmex" "tmuxomatic" "tmuxp" ];
        description = "Enable a tmux session manager";
      };

      # theme
      theme = mkOption {
        default = null;
        example = "dracula";
        type = types.enum [
          ""
        ];
      };

      statusBar = {
        plugins = mkOption {
          default = [];
          example = [ "spotify-info" "pomodoro-plus" "weather" "battery" ];
          type  = types.enum [
            ""
          ];
        };
        left = {
          default = "";
          example = "@TODO: put something here";
          type = types.str;
        };
        right = {
          default = "";
          example = "@TODO: put something here";
          type = types.str;
        };
      };

      # plugins
      plugins = mkOption {
        type = types.listOf str;
        default = [];
        example = [
          "sensible"
          "better-mouse-mode"
        ];
        description = "List of plugins to install";
      };

      # terminal
      terminal = mkOption {
        default = defaults.terminal;
        example = "screen-256color";
        type = types.str;
        description = "Sets $TERM";
      };
    };
  };

  config = mkIf cfg.enable (mkMerge ([
    {
      environment.systemPackages = [ cfg.package ]
      ++ optional cfg.sessionManager cfg.sessionManager;
    }

    { xdg.configFile."tmux/tmux.conf".text = mkBefore config; }
    { xdg.configFile."tmux/tmux.conf".text = mkAfter cfg.extraConfig; }

    (mkIf (cfg.plugins != []) configPlugins )

  ]));
}
