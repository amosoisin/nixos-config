{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;

    includes = [
      { path = "~/.gitconfig-user"; }
    ];

    extraConfig = {
      core = {
        editor = "nvim";
        pager = "less";
        quotepath = false;
      };

      color = {
        ui = true;
      };

      http = {
        postBuffer = 157286400;
      };

      safe = {
        directory = "*";
      };

      diff = {
        indentHeuristic = true;
      };
    };

    aliases = {
      s = "status";
      g = "log --oneline --decorate --graph --branches --tags --remotes";
      difff = "diff --word-diff";
      cm = "commit";
      sub = "submodule";
      for = "submodule foreach";
    };
  };

  programs.git.ignores = [
    # OS
    ".DS_Store"
    "Thumbs.db"

    # Editors
    "*.swp"
    "*.swo"
    "*~"
    ".idea/"
    ".vscode/"
    "*.sublime-*"

    # Nix
    "result"
    "result-*"

    # Environment
    ".env"
    ".env.local"
    ".envrc"

    # Logs
    "*.log"

    # Dependencies
    "node_modules/"
    "__pycache__/"
    "*.pyc"
    ".venv/"
    "venv/"
    "target/"
  ];
}
