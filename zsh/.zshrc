# If you come from bash you might have to change your $PATH.
export PATH=$HOME/go/bin:$HOME/.cargo/bin:$HOME/.bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
if [[ "$TERM" == "xterm-kitty" ]] || [[ "$TERM" == "xterm-ghostty" ]] || [[ "$TERM" == "tmux-256color" ]]; then
  ZSH_THEME="robbyrussell"
else
  ZSH_THEME="bureau"
fi

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git fast-syntax-highlighting colored-man-pages fzf-zsh-plugin)

source $ZSH/oh-my-zsh.sh

# User configuration
source $HOME/.secrets/secrets.env


# You may need to manually set your language environment
export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

# Set the manpager program
export MANPAGER="nvim +Man!"

# Set screenshot directory
export XDG_SCREENSHOTS_DIR="$HOME/Pictures/Screenshots"
export DOTFILES_DIR="$HOME/.dotfiles"

# Enable Carapace completion engine
export CARAPACE_BRIDGES='zsh,fish,bash,inshellisense' # optional
zstyle ':completion:*' format $'\e[2;37mCompleting %d\e[m'
source <(carapace _carapace)

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
if [[ "$TERM" == "xterm-kitty" ]]; then
  alias ssh-jellyfin='kitten ssh $JELLYFIN_USER@$JELLYFIN_ADDRESS'
  alias ssh-server='kitten ssh $SERVER_USER@$SERVER_ADDRESS'
else
  alias ssh-jellyfin='ssh $JELLYFIN_USER@$JELLYFIN_ADDRESS'
  alias ssh-server='ssh $SERVER_USER@$SERVER_ADDRESS'
fi

alias pcirescan='sudo $HOME/.scripts/pcirescan.sh'
alias sftp-server='sftp $SERVER_USER@$SERVER_ADDRESS:/downloads'
alias sftp-jellyfin='sftp $JELLYFIN_USER@$JELLYFIN_ADDRESS'
alias code-server='sshfs $SERVER_USER@$SERVER_ADDRESS:$HOME/code-files /mnt/code-server'
alias code-unmount='fusermount3 -u /mnt/code-server'
alias empty-trash='sudo rm -rf --interactive $HOME/.Trash/*'
alias esp32serial='screen /dev/ttyUSB0 115200'

#Use zoxide instead of cd
eval "$(zoxide init --cmd cd zsh)"

# Set the starship prompt
if [[ "$TERM" == "xterm-kitty" ]] || [[ "$TERM" == "xterm-ghostty" ]] || [[ "$TERM" == "tmux-256color" ]]; then
  eval "$(starship init zsh)"
  alias ls="eza --icons"
  alias duf='duf --hide-fs tmpfs,devtmpfs'
  alias vim='nvim'
else
  alias ls="eza"
  alias duf='duf --hide-fs tmpfs,devtmpfs -style ascii'
fi
alias la="ls -a"

export FZF_DEFAULT_OPTS=" \
--color=bg+:#3b3b3e,bg:#161617,spinner:#e6b99d,hl:#ea83a5 \
--color=fg:#c9c7cd,header:#90b99f,info:#aca1cf,pointer:#f5e0dc \
--color=marker:#e6b99d,fg+:#c9c7cd,prompt:#aca1cf,hl+:#e29eca"

export PROMPT_EOL_MARK=''
setopt PROMPT_SP

# Set theming for TTY terminals
if [ "$TERM" = linux ] && command -v ttyscheme >/dev/null; then
	ttyscheme "kanagawa"
fi

# Autostart hyprland at login
if [ "$TERM" != "tmux-256color" ]; then
  if uwsm check may-start; then
      exec uwsm start hyprland.desktop
  fi
fi
