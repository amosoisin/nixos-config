{ config, pkgs, ... }:

{
  # ===== Zsh設定 =====
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    # ログイン時の初期化
    initContent = ''
      # Git ユーザー設定の自動生成（存在しない場合のみ）
      if [ ! -f ~/.gitconfig-user ] && [ -t 0 ]; then
          echo "Git ユーザー設定が見つかりません。設定を作成します。"
          echo ""
          printf "Git user.name を入力してください: "
          read git_user_name
          printf "Git user.email を入力してください: "
          read git_user_email
          cat > ~/.gitconfig-user << EOF
      [user]
          name = $git_user_name
          email = $git_user_email
      EOF
          echo ""
          echo "~/.gitconfig-user を作成しました。"
          echo ""
      fi

      PATH=$PATH:/home/nixos/.local/bin/
    '';

    shellAliases = {
      y = "yazi-launch";
      yazi = "yazi-launch";
    };

    plugins = [
      {
        name = "you-should-use";
        src = pkgs.zsh-you-should-use;
        file = "share/zsh/plugins/you-should-use/you-should-use.plugin.zsh";
      }
      {
        name = "fzf-tab";
        src = pkgs.zsh-fzf-tab;
        file = "share/fzf-tab/fzf-tab.plugin.zsh";
      }
      {
        name = "forgit";
        src = pkgs.zsh-forgit;
        file = "share/zsh/zsh-forgit/forgit.plugin.zsh";
      }
      {
        name = "zsh-completions";
        src = pkgs.zsh-completions;
        file = "share/zsh/zsh-completions/zsh-completions.plugin.zsh";
      }
      {
        name = "zsh-autosuggestions";
        src = pkgs.zsh-autosuggestions;
        file = "share/zsh/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh";
      }
      {
        name = "zsh-syntax-highlighting";
        src = pkgs.zsh-syntax-highlighting;
        file = "share/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh";
      }
      {
        name = "yazi";
        src = ./.;
        file = "yazi.zsh";
      }
      {
        name = "wsl";
        src = ./.;
        file = "wsl.zsh";
      }
    ];
  };
}
