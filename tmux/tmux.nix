{ config, pkgs, lib, ... }:

{
  # ===== tmux設定 =====
  programs.tmux = {
    enable = true;
    shell = "${pkgs.zsh}/bin/zsh";
    terminal = "tmux-256color";
    plugins = with pkgs.tmuxPlugins; [
      sensible
      yank
      resurrect
      continuum
    ];
    extraConfig = ''
      # マウスサポート
      set -g mouse on

      # プレフィックスキーをC-aに変更
      unbind C-b
      set -g prefix C-a
      bind C-a send-prefix

      # ペイン分割のキーバインド
      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"

      # Vimスタイルのペイン移動
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R

      # ペインリサイズ
      bind -r H resize-pane -L 5
      bind -r J resize-pane -D 5
      bind -r K resize-pane -U 5
      bind -r L resize-pane -R 5

      # ウィンドウ番号を1から開始
      set -g base-index 1
      setw -g pane-base-index 1

      # ウィンドウを閉じた時に番号を詰める
      set -g renumber-windows on
    '';
  };
}