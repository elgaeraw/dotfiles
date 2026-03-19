# =========================
# Environment
# =========================

set -gx EDITOR nvim
set -gx VISUAL nvim
set -gx PATH $HOME/.cargo/bin $PATH

# =========================
# Aliases
# =========================

# General
alias c="flatpak run com.visualstudio.code"
alias py="python"
alias pwn="ssh hacker@pwn.college"
alias vim="nvim"
alias v="nvim"
# Git
alias gs="git status"
alias ga="git add"
alias gaa="git add -A"
alias gc="git commit"
alias gcm="git commit -m"
alias gp="git push"
alias gpo="git push origin"

# DNF
alias dnfs="dnf search"
alias dnfu="sudo dnf update"
alias dnfi="sudo dnf install"
alias dnfr="sudo dnf remove"
alias update="sudo dnf update"

# Rust
alias cb="clear; cargo build"
alias cr="clear; cargo run"
alias cc="clear; cargo check"
alias cl="clear; cargo clean"
alias ct="clear; cargo test"
alias ce="clear; cargo expand"
alias cet="clear; cargo expand --lib --tests"

# VPN
alias vpn="sudo /home/elgaeraw/Code/rust/vpn/target/release/vpn"

# Rsync
alias rsync-local-repos="sudo rsync -rlptvh rsync.opensuse.org::opensuse-full-with-factory /srv/local-repos --stats --progress --exclude-from=/srv/local-repos/excludelist"

# =========================
# Functions
# =========================

function mkcd
    mkdir $argv[1]
    cd $argv[1]
end

function clean
    sudo dnf autoremove
end

function dotfiles_sync
    cp -r ~/.config ~/dotfiles/
    cp ~/.zshrc ~/dotfiles/
    # cp -r ~/.fonts ~/dotfiles/
    mkdir -p ~/dotfiles
    cd ~/dotfiles
    git add -A
    git commit
    git push
end

function cpr
    set filename (string split '.' $argv[1])[1]
    g++ $argv[1] -o ./build/$filename
    ./build/$filename
end

function jr
    set filename (string split '.' $argv[1])[1]
    javac $argv[1] -d ./build
    java -cp ./build $filename
end

function asr
    set filename (string split '.' $argv[1])[1]
    nasm -f elf32 -o $filename.o $argv[1]
    ld -m elf_i386 -o $filename $filename.o
    ./$filename
    rm $filename $filename.o
end

# Auto attach/create tmux session "temp"
if not set -q TMUX
    set base temp

    if tmux has-session -t $base 2>/dev/null
        set i 1
        while tmux has-session -t "$base-$i" 2>/dev/null
          set i (math $i + 1)
        end

        set newsession "$base-$i"

        tmux new-session -d -t $base -s $newsession

        tmux new-window -t $newsession

        tmux attach -t $newsession
    else
        tmux new -s $base
    end
end

# =========================
# Fun
# =========================

fortune | cowsay -f tux
