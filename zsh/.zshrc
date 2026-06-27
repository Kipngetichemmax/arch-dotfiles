

# ─────────────────────────────────────────────
#  .zshrc — Optimized for Dev / Data / DevOps
# ─────────────────────────────────────────────


# ── HISTORY ────────────────────────────────────
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_DUPS       # Don't save duplicate commands
setopt HIST_IGNORE_SPACE      # Don't save commands starting with a space
setopt SHARE_HISTORY          # Share history across all terminal sessions
setopt APPEND_HISTORY         # Append to history file, don't overwrite


# ── ZSH OPTIONS ────────────────────────────────
setopt AUTO_CD                # Type a directory name to cd into it
setopt CORRECT                # Suggest corrections for mistyped commands
setopt GLOB_COMPLETE          # Tab-complete glob patterns
setopt NO_BEEP                # Silence the terminal bell


# ── COMPLETION ─────────────────────────────────
autoload -Uz compinit && compinit

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' list-colors ''
zstyle ':completion::complete:*' gain-privileges 1


# ── ZINIT (Plugin Manager) ─────────────────────
# Install: sh -c "$(curl -fsSL https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"
if [[ -f "$HOME/.local/share/zinit/zinit.git/zinit.zsh" ]]; then
  source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"

  zinit light zsh-users/zsh-syntax-highlighting
  zinit light zsh-users/zsh-autosuggestions
  zinit light zsh-users/zsh-completions
  zinit light agkozak/zsh-z
fi


# ── STARSHIP PROMPT ────────────────────────────
# Install: curl -sS https://starship.rs/install.sh | sh
eval "$(starship init zsh)"


# ── PATH ───────────────────────────────────────
export PATH="$HOME/.local/bin:$HOME/bin:/usr/local/bin:$PATH"


# ── EDITOR & LANG ──────────────────────────────
export EDITOR="nano"
export VISUAL="$EDITOR"
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"


# ── GIT ALIASES ────────────────────────────────
alias g="git"
alias gs="git status"
alias ga="git add"
alias gaa="git add --all"
alias gc="git commit -m"
alias gca="git commit --amend --no-edit"
alias gp="git push"
alias gpl="git pull"
alias gl="git log --oneline --graph --decorate --all"
alias gd="git diff"
alias gco="git checkout"
alias gcb="git checkout -b"
alias gb="git branch"
alias gst="git stash"
alias gstp="git stash pop"


# ── DOCKER ALIASES ─────────────────────────────
alias d="docker"
alias dc="docker compose"
alias dcu="docker compose up -d"
alias dcd="docker compose down"
alias dcl="docker compose logs -f"
alias dps="docker ps --format 'table {{.Names}}\t{{.Status}}\t{{.Ports}}'"
alias dimg="docker images"
alias dprune="docker system prune -af --volumes"


# ── NODE / NPM ─────────────────────────────────
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && source "$NVM_DIR/bash_completion"

alias ni="npm install"
alias nid="npm install --save-dev"
alias nig="npm install -g"
alias nr="npm run"
alias ns="npm start"
alias nt="npm test"
alias nci="rm -rf node_modules && npm install"


# ── PYTHON / CONDA / VENV ─────────────────────
# Conda: uncomment and adjust path if using Miniconda/Anaconda
# [ -f "$HOME/miniconda3/etc/profile.d/conda.sh" ] && source "$HOME/miniconda3/etc/profile.d/conda.sh"

alias venv="python3 -m venv .venv"
alias activate="source .venv/bin/activate"
alias deactivate="deactivate 2>/dev/null || true"

alias py="python3"
alias pip="pip3"
alias pipi="pip3 install"
alias pipu="pip3 install --upgrade"
alias pipf="pip3 freeze > requirements.txt"
alias pipr="pip3 install -r requirements.txt"


# ── GENERAL ALIASES ────────────────────────────
alias ls="ls --color=auto"
alias ll="ls -lAh --color=auto"
alias la="ls -A --color=auto"
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias mkdir="mkdir -pv"
alias cp="cp -iv"
alias mv="mv -iv"
alias grep="grep --color=auto"
alias df="df -h"
alias du="du -sh *"
alias ports="ss -tulnp"
alias myip="curl -s ifconfig.me"
alias reload="source ~/.zshrc"


# ── USEFUL FUNCTIONS ───────────────────────────

# Create a directory and cd into it
mkcd() { mkdir -p "$1" && cd "$1"; }

# Extract any archive type
extract() {
  case "$1" in
    *.tar.bz2)  tar xjf "$1"   ;;
    *.tar.gz)   tar xzf "$1"   ;;
    *.tar.xz)   tar xJf "$1"   ;;
    *.bz2)      bunzip2 "$1"   ;;
    *.gz)       gunzip "$1"    ;;
    *.zip)      unzip "$1"     ;;
    *.7z)       7z x "$1"      ;;
    *.rar)      unrar x "$1"   ;;
    *)          echo "Don't know how to extract '$1'" ;;
  esac
}

# Serve current directory over HTTP
serve() { python3 -m http.server "${1:-8000}"; }

# Show what's running on a port
port() { lsof -i :"$1"; }

# Git: init + first commit in one shot
ginit() {
  git init
  git add --all
  git commit -m "Initial commit"
}

# ─────────────────────────────────────────────
