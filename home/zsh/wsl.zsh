# checks to see if we are in a windows or linux dir
function isWinDir {
    dpath=$(readlink -f "$PWD")
    case "$dpath" in
        /mnt/*) return $(true);;
        *) return $(false);;
    esac
}

# wrap the git command to either run windows git or linux
function git {
    if isWinDir
    then
        git.exe "$@"
    else
        /etc/profiles/per-user/nixos/bin/git "$@"
    fi
}

# wrap the git command to either run windows git or linux
function lazygit {
    if isWinDir
    then
        lazygit.exe "$@"
    else
        /etc/profiles/per-user/nixos/bin/lazygit "$@"
    fi
}
