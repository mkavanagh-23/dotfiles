# If you come from bash you might have to change your $PATH.
export PATH=$HOME/.cargo/bin:$HOME/.bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
if [[ "$TERM" == "xterm-kitty" ]]; then
  ZSH_THEME="robbyrussell"
else
  ZSH_THEME="bureau"
fi

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git fast-syntax-highlighting kitty web-search colored-man-pages)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

# Set screenshot directory
export XDG_SCREENSHOTS_DIR="$HOME/Pictures/Screenshots"
export SECRETS_DIR="$HOME/.secrets"
export DOTFILES_DIR="$HOME/.dotfiles"

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
JELLYFIN_ADDRESS="$(cat $SECRETS_DIR/jellyfin_address)"
JELLYFIN_USER="$(cat $SECRETS_DIR/jellyfin_user)"
SERVER_ADDRESS="$(cat $SECRETS_DIR/server_address)"
SERVER_USER="$(cat $SECRETS_DIR/server_user)"
if [[ "$TERM" == "xterm-kitty" ]]; then
  alias ssh-jellyfin='kitten ssh $JELLYFIN_USER@$JELLYFIN_ADDRESS'
  alias ssh-server='kitten ssh $SERVER_USER@$SERVER_ADDRESS'
else
  alias ssh-jellyfin='ssh $JELLYFIN_USER@$JELLYFIN_ADDRESS'
  alias ssh-server='ssh $SERVER_USER@$SERVER_ADDRESS'
fi

alias sftp-server='sftp $SERVER_USER@$SERVER_ADDRESS:/downloads'
alias sftp-jellyfin='sftp $JELLYFIN_USER@$JELLYFIN_ADDRESS'
alias update='sudo pacman -Syu && paru'

#Use zoxide instead of cd
eval "$(zoxide init --cmd cd zsh)"

# Set the starship prompt
if [[ "$TERM" == "xterm-kitty" ]]; then
  eval "$(starship init zsh)"
  alias ls="eza --icons"
  alias duf='duf --hide-fs tmpfs,devtmpfs'
else
  alias ls="eza"
  alias duf='duf --hide-fs tmpfs,devtmpfs -style ascii'
fi
alias la="ls -a"

export FZF_DEFAULT_OPTS=" \
--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
--color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"

export PROMPT_EOL_MARK=''
setopt PROMPT_SP
