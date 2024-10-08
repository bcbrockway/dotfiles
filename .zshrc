# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
  export ZSH="/home/bbrockway/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
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
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
asdf
git
kube-ps1
kubectl
timer
)

source $ZSH/oh-my-zsh.sh

# User configuration

export GOPATH=~/go
export PATH=$PATH:$HOME/bin:$GOPATH/bin
export FLUX_FORWARD_NAMESPACE=flux-apps

# Android SDK
export PATH=$PATH:/data/android_sdk/cmdline-tools/latest/bin:/data/android_sdk/platform-tools

# AWS
export AWS_PAGER=""

# Docker
export DOCKER_BUILDKIT=1
export COMPOSE_DOCKER_CLI_BUILD=1

# ec2-ssh
export PATH=$PATH:/data/gitlab.com/mintel/satoshi/tools/ec2-ssh

# my scripts
export PATH=$PATH:~/scripts

# krew
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

# pipx
export PATH="$PATH:/home/bbrockway/.local/bin"

# cargo
export PATH="$PATH:/home/bbrockway/.cargo/bin"

# eks-power
export PATH="$PATH:/data/gitlab.com/mintel/satoshi/tools/eks-power"

# secrets-manager-copy
export PATH="$PATH:/data/gitlab.com/mintel/satoshi/tools/aws-secrets-manager-copy"

# GPG config
export GNUPGHOME=$HOME/.gnupg

# pass config
export PASSWORD_STORE_DIR=/data/gitlab.com/mintel/infra/secret-store-v1

# rofi config
export PATH=$HOME/.config/rofi/scripts:$PATH

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
export EDITOR='vim'

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
export SSH_KEY_PATH="~/.ssh/rsa_id"

SSH_ENV="$HOME/.ssh/environment"

function start_agent {
    echo "Initialising new SSH agent..."
    /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
    echo succeeded
    chmod 600 "${SSH_ENV}"
    . "${SSH_ENV}" > /dev/null
    /usr/bin/ssh-add ~/.ssh/id_rsa
    /usr/bin/ssh-add ~/.ssh/id_rsa_mintel
}

# Source SSH settings, if applicable

if [ -f "${SSH_ENV}" ]; then
    . "${SSH_ENV}" > /dev/null
    #ps ${SSH_AGENT_PID} doesn't work under cywgin
    ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
        start_agent;
    }
else
    start_agent;
fi

# kube-ps1
PROMPT='%{$fg_bold[green]%}${AWS_VAULT}%{$reset_color%}${ret_status} %{$fg[cyan]%}%~%{$reset_color%} $(git_prompt_info)$(kube_ps1)
$ '
if [ -n "$AWS_PROFILE" ]; then
  export PROMPT="$(tput setab 1)<<${AWS_PROFILE}>>$(tput sgr0) ${PROMPT}"
  if ! aws sts get-caller-identity; then
    aws sso login --profile "$AWS_PROFILE"
  fi
fi;

# Enable Go Modules
export GO111MODULE=on

# Include Files

INCLUDES=(
  "$HOME/.bash_aliases"
  "$HOME/.secrets"
  "$HOME/.zshrc-ext"
)

for include in "${INCLUDES[@]}"; do
  if [[ -f $include ]]; then
    source $include
  fi
done

fpath+=${ZDOTDIR:-~}/.zsh_functions

if [ -e /home/bbrockway/.nix-profile/etc/profile.d/nix.sh ]; then . /home/bbrockway/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer

export PATH="/usr/local//bin:$PATH"
export PATH="/usr/local/bin/bin:$PATH"

eval "$(direnv hook zsh)"
