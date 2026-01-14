{ config, pkgs, lib, ... }:

{
  # ===== tmux設定 =====
  programs.tmux = {
    enable = true;
    shell = "${pkgs.zsh}/bin/zsh";
    shortcut = "b";
    terminal = "tmux-256color";
    keyMode = "vi";
    baseIndex = 1;
    mouse = true;
    escapeTime = 0;
    newSession = true;
    historyLimit = 50000;

    # Force tmux to use /tmp for sockets (WSL2 compat)
    secureSocket = false;

    # plugins
    plugins = with pkgs.tmuxPlugins; [
      sensible
      yank
      resurrect
      continuum
      pain-control
      {
        plugin = dracula;
        extraConfig = ''
          set -g @dracula-plugins "git cwd"
          set -g @dracula-cpu-usage-colors "pink dark_gray"
          set -g @dracula-show-flags true
          set -g @dracula-show-powerline true
          set -g @dracula-git-show-remote true
          set -g @dracula-git-show-dirty true
        '';
      }
    ];
    extraConfig = ''
      # ===== 色設定 =====
      set -g terminal-overrides 'xterm:colors=256'
      set-option -ga terminal-overrides ',xterm-256color:Tc'

      # ===== シンクロペイン =====
      # トグル
      bind S set-window-option synchronize-panes
      # 開始・終了を別キーに登録
      bind a set-window-option synchronize-panes on
      bind b set-window-option synchronize-panes off
    '';
  };
}
