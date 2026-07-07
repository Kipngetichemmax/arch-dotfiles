
# =============================================================================
# ~/.zshrc — Arch Linux + Hyprland
# =============================================================================


# -----------------------------------------------------------------------------
# CORE OPTIONS
# -----------------------------------------------------------------------------

# Don't run if not interactive
[[ $- != *i* ]] && return

# Enable extended glob patterns (** recursive, ^negation, etc.)
setopt EXTENDED_GLOB

# cd by just typing the directory name
setopt AUTO_CD

# Correct typos in commands
setopt CORRECT

# Allow comments in interactive shell (like bash)
setopt INTERACTIVE_COMMENTS

# No beep ever
setopt NO_BEEP

# Treat #, ~, ^ as part of patterns
setopt EXTENDED_GLOB


# -----------------------------------------------------------------------------
# HISTORY
# -----------------------------------------------------------------------------

HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=50000

setopt HIST_IGNORE_DUPS       # Don't store consecutive duplicates
setopt HIST_IGNORE_ALL_DUPS   # Remove older duplicate entries
setopt HIST_IGNORE_SPACE      # Don't store commands starting with a space
setopt HIST_SAVE_NO_DUPS      # Don't write duplicates to the file
setopt HIST_REDUCE_BLANKS     # Strip extra whitespace
setopt SHARE_HISTORY          # Share history across sessions in real time
setopt APPEND_HISTORY         # Append instead of overwrite


# -----------------------------------------------------------------------------
# COMPLETION ENGINE
# -----------------------------------------------------------------------------

autoload -Uz compinit

# Only regenerate the completion dump once a day
if [[ -n ~/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi

# Menu-driven completion (tab cycles through options)
zstyle ':completion:*' menu select

# Case-insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# Color ls output in completions
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# Show descriptions for options
zstyle ':completion:*:*:*:*:descriptions' format '%F{green}-- %d --%f'

# Group completions by category
zstyle ':completion:*' group-name ''

# Complete . and .. as directories
zstyle ':completion:*' special-dirs true

# Fuzzy match completions
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric

# Autocomplete for kill
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'


# -----------------------------------------------------------------------------
# KEYBINDINGS
# -----------------------------------------------------------------------------

# Emacs-style keybinds (familiar from bash)
bindkey -e

# Better history search
bindkey '^R' history-incremental-search-backward
bindkey '^S' history-incremental-search-forward

# Arrow keys for history prefix search
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey '^[[A' up-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search
bindkey '^[OA' up-line-or-beginning-search
bindkey '^[OB' down-line-or-beginning-search

# Word navigation — Ctrl+Left / Ctrl+Right
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word

# Alt+Backspace to delete a word
bindkey '^[^?' backward-kill-word

# Home / End
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line
bindkey '^[[1~' beginning-of-line
bindkey '^[[4~' end-of-line

# Delete key
bindkey '^[[3~' delete-char


# -----------------------------------------------------------------------------
# ENVIRONMENT VARIABLES
# -----------------------------------------------------------------------------

export EDITOR='nvim'
export VISUAL='nvim'
export PAGER='less'
export LESS='-R --mouse'

# XDG base dirs
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_STATE_HOME="$HOME/.local/state"

# Wayland / Hyprland
export XDG_SESSION_TYPE=wayland
export XDG_CURRENT_DESKTOP=Hyprland
export XDG_SESSION_DESKTOP=Hyprland
export MOZ_ENABLE_WAYLAND=1
export QT_QPA_PLATFORM=wayland
export QT_QPA_PLATFORMTHEME=qt6ct
export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
export SDL_VIDEODRIVER=wayland
export CLUTTER_BACKEND=wayland
export _JAVA_AWT_WM_NONREPARENTING=1

# Electron/Chromium on Wayland (uncomment if needed)
# export ELECTRON_OZONE_PLATFORM_HINT=wayland

# PATH
export PATH="$HOME/.local/bin:$HOME/bin:$PATH"

# Mason LSP binaries
export PATH="$HOME/.local/share/nvim/mason/bin:$PATH"

# Colored man pages
export MANPAGER='less -R --use-color -Dd+r -Du+b'


# -----------------------------------------------------------------------------
# ALIASES
# -----------------------------------------------------------------------------

# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ~='cd ~'
alias -- -='cd -'

# Listing
if command -v eza &>/dev/null; then
  alias ls='eza --icons --group-directories-first'
  alias ll='eza -lah --icons --group-directories-first --git'
  alias lt='eza --tree --icons --level=2'
  alias lta='eza --tree --icons --level=2 -a'
else
  alias ls='ls --color=auto --group-directories-first'
  alias ll='ls -lahF --color=auto'
fi

# bat as cat
if command -v bat &>/dev/null; then
  alias cat='bat --style=plain'
  alias catp='bat'
fi

# search
alias ff='fd'
alias rgf='rg --files'

# file management
alias md='mkdir -p'

# grep
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

# Pacman
alias pac='sudo pacman -S'
alias pacr='sudo pacman -Rns'
alias pacu='sudo pacman -Syu'
alias pacs='pacman -Ss'
alias pacq='pacman -Qi'
alias paclf='pacman -Ql'
alias pacown='pacman -Qo'
alias pacorphans='pacman -Qdt'

# yay or paru — uncomment whichever you use
# alias y='yay -S'
# alias yu='yay -Syu'
# alias p='paru -S'
# alias pu='paru -Syu'

# Git
alias g='git'
alias gs='git status'
alias ga='git add'
alias gaa='git add .'
alias gc='git commit -m'
alias gca='git commit --amend'
alias gp='git push'
alias gpl='git pull'
alias gd='git diff'
alias gds='git diff --staged'
alias gl='git log --oneline --graph --decorate'
alias gla='git log --oneline --graph --decorate --all'
alias gsw='git switch'
alias gswc='git switch -c'
alias gb='git branch'
alias gba='git branch -a'
alias gst='git stash'
alias gstp='git stash pop'

# Safety
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias mkdir='mkdir -pv'

# System
alias df='df -h'
alias du='du -h'
alias free='free -h'
alias top='btop 2>/dev/null || htop 2>/dev/null || top'
alias ip='ip -color=auto'
alias ports='ss -tulpn'

# Misc
alias cls='clear'
alias q='exit'
alias reload='source ~/.zshrc && echo "zshrc reloaded"'
alias zshrc='$EDITOR ~/.zshrc'
alias hyprconf='$EDITOR ~/.config/hypr/hyprland.lua'
alias lg='lazygit'

# -----------------------------------------------------------------------------
# FUNCTIONS
# -----------------------------------------------------------------------------

# Make dir and cd into it
mkcd() { mkdir -p "$1" && cd "$1" }

# Extract any archive
extract() {
  if [[ -f "$1" ]]; then
    case "$1" in
      *.tar.bz2)   tar xjf "$1"        ;;
      *.tar.gz)    tar xzf "$1"        ;;
      *.tar.xz)    tar xJf "$1"        ;;
      *.tar.zst)   tar --zstd -xf "$1" ;;
      *.bz2)       bunzip2 "$1"        ;;
      *.rar)       unrar x "$1"        ;;
      *.gz)        gunzip "$1"         ;;
      *.tar)       tar xf "$1"         ;;
      *.tbz2)      tar xjf "$1"        ;;
      *.tgz)       tar xzf "$1"        ;;
      *.zip)       unzip "$1"          ;;
      *.Z)         uncompress "$1"     ;;
      *.7z)        7z x "$1"           ;;
      *.zst)       zstd -d "$1"        ;;
      *)           echo "'$1' cannot be extracted" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# Quick file backup
bak() { cp "$1"{,.bak} && echo "Backed up $1 → $1.bak" }

# Show PATH one entry per line
path() { echo "$PATH" | tr ':' '\n' }

# Open file/URL with default app (background, no terminal noise)
open() { nohup xdg-open "$@" &>/dev/null & disown }

# Search files (rg if available, else grep)
search() {
  if command -v rg &>/dev/null; then
    rg "$@"
  else
    grep -rn "$@" .
  fi
}

# Quick calculator
calc() { echo "scale=4; $*" | bc -l }

# Disk usage sorted
dusort() { du -h --max-depth=1 "${1:-.}" | sort -hr }

# cd and list
cl() {
    cd "$1" && eza --icons --group-directories-first
}


# -----------------------------------------------------------------------------
# PLUGIN MANAGER — zinit
# -----------------------------------------------------------------------------
# Install zinit first (run once):
#   bash -c "$(curl -fsSL https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"

if [[ -f "$HOME/.local/share/zinit/zinit.git/zinit.zsh" ]]; then
  source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"

  zinit light zsh-users/zsh-autosuggestions
  zinit light zsh-users/zsh-syntax-highlighting
  zinit light Aloxaf/fzf-tab
  zinit light zsh-users/zsh-completions

  export ZSH_AUTOSUGGEST_STRATEGY=(history completion)
  export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
  bindkey '^[^[[C' autosuggest-accept   # Alt+Right accepts suggestion

  zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza --icons --tree --level=1 $realpath 2>/dev/null || ls $realpath'
  zstyle ':fzf-tab:complete:*' fzf-flags --height=60% --border=sharp
fi


# -----------------------------------------------------------------------------
# fzf
# -----------------------------------------------------------------------------

if command -v fzf &>/dev/null; then
  source /usr/share/fzf/key-bindings.zsh 2>/dev/null
  source /usr/share/fzf/completion.zsh 2>/dev/null

  export FZF_DEFAULT_OPTS="
    --height=40%
    --layout=reverse
    --border=sharp
    --info=inline
    --preview-window=right:50%:wrap
  "

  if command -v fd &>/dev/null; then
    export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
  fi
fi


# -----------------------------------------------------------------------------
# zoxide — smarter cd
# -----------------------------------------------------------------------------

if command -v zoxide &>/dev/null; then
  eval "$(zoxide init zsh)"
  alias cd='z'
  alias cdi='zi'
fi


# -----------------------------------------------------------------------------
# atuin — history database
# -----------------------------------------------------------------------------

if command -v atuin &>/dev/null; then
  eval "$(atuin init zsh --disable-up-arrow)"
fi


# -----------------------------------------------------------------------------
# PROMPT — Starship
# -----------------------------------------------------------------------------
# Install: sudo pacman -S starship
# Config:  ~/.config/starship.toml

if command -v starship &>/dev/null; then
  eval "$(starship init zsh)"
else
  # Fallback prompt with git branch
  autoload -Uz vcs_info
  precmd() { vcs_info }
  zstyle ':vcs_info:git:*' formats ' (%b)'
  setopt PROMPT_SUBST
  PROMPT='%F{cyan}%n%f@%F{blue}%m%f %F{yellow}%~%f%F{green}${vcs_info_msg_0_}%f %# '
fi


# =============================================================================
# END OF .zshrc
# =============================================================================
