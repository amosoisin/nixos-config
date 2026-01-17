{ config, lib, pkgs, ... }:

{
  # ===== プライマリーユーザー設定 =====
  system.primaryUser = "amosoisin";

  # ===== ユーザー定義 =====
  users.users.amosoisin = {
    name = "amosoisin";
    home = "/Users/amosoisin";
    shell = pkgs.zsh;
  };

  # ===== macOSシステム設定 =====
  system.defaults = {
    # Dockの設定
    dock = {
      autohide = true;                    # Dockを自動的に隠す
      autohide-delay = 0.0;               # 隠すまでの遅延なし
      autohide-time-modifier = 0.2;       # アニメーション速度
      orientation = "bottom";             # Dockの位置
      show-recents = false;               # 最近使ったアプリを表示しない
      tilesize = 48;                      # アイコンサイズ
      minimize-to-application = true;     # アプリケーションアイコンに最小化
      mru-spaces = false;                 # 最近使用した順でSpaceを並べない
    };

    # Finderの設定
    finder = {
      AppleShowAllExtensions = true;      # すべてのファイル拡張子を表示
      AppleShowAllFiles = true;           # 隠しファイルを表示
      FXEnableExtensionChangeWarning = false;  # 拡張子変更の警告を無効化
      FXPreferredViewStyle = "Nlsv";      # リスト表示をデフォルトに
      ShowPathbar = true;                 # パスバーを表示
      ShowStatusBar = true;               # ステータスバーを表示
      _FXShowPosixPathInTitle = true;     # タイトルバーにフルパスを表示
    };

    # NSGlobalDomain（グローバル設定）
    NSGlobalDomain = {
      AppleInterfaceStyle = "Dark";       # ダークモード
      AppleKeyboardUIMode = 3;            # キーボードでフルコントロール
      ApplePressAndHoldEnabled = false;   # キーリピートを有効化（長押し無効）
      InitialKeyRepeat = 15;              # キーリピート開始までの時間
      KeyRepeat = 2;                      # キーリピート速度
      NSAutomaticCapitalizationEnabled = false;    # 自動大文字化を無効
      NSAutomaticDashSubstitutionEnabled = false;  # 自動ダッシュ変換を無効
      NSAutomaticPeriodSubstitutionEnabled = false; # 自動ピリオド挿入を無効
      NSAutomaticQuoteSubstitutionEnabled = false;  # 自動クォート変換を無効
      NSAutomaticSpellingCorrectionEnabled = false; # 自動スペル修正を無効
      NSNavPanelExpandedStateForSaveMode = true;    # 保存ダイアログを常に展開
      NSNavPanelExpandedStateForSaveMode2 = true;   # 保存ダイアログを常に展開（v2）
      _HIHideMenuBar = false;             # メニューバーを隠さない
    };

    # トラックパッドの設定
    trackpad = {
      Clicking = true;                    # タップでクリック
      TrackpadRightClick = true;          # 二本指クリックで右クリック
      TrackpadThreeFingerDrag = false;    # 三本指ドラッグを無効
    };

    # スクリーンセーバーの設定
    screensaver = {
      askForPassword = true;              # スクリーンセーバー解除時にパスワード要求
      askForPasswordDelay = 5;            # パスワード要求までの遅延（秒）
    };

    # その他の設定
    CustomUserPreferences = {
      # スクリーンショットの保存場所と形式
      "com.apple.screencapture" = {
        location = "~/Pictures/Screenshots";
        type = "png";
      };
    };
  };

  # ===== キーボード設定 =====
  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToControl = true;        # CapsLockをControlに変更
  };

  # ===== State Version =====
  system.stateVersion = 5;
}
