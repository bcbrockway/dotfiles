#!/bin/bash

###########
##  AWS  ##
###########

ae () {
  AWS_PROFILE="$1" zsh
}

adecode () {
  aws sts decode-authorization-message --encoded-message="$1" --query="DecodedMessage" --output="text" | jq .
}

###################
##  Directories  ##
###################

alias acdb="cd /data/gitlab.com/mintel/satoshi/kubernetes/jsonnet/tanka/argocd-bootstrap"
alias ail="cd /data/gitlab.com/mintel/satoshi/infrastructure/aws-infrastructure-live"
alias aim="cd /data/gitlab.com/mintel/satoshi/infrastructure/aws-infrastructure-modules"
alias archinst="cd /data/bcbrockway/archinstall "
alias argocd-bootstrap="cd /data/gitlab.com/mintel/satoshi/kubernetes/jsonnet/tanka/argocd-bootstrap"
alias docs="cd /data/gitlab.com/mintel/satoshi/docs "
alias ds="cd /data/gitlab.com/mintel/satoshi "
alias dsk="cd /data/gitlab.com/mintel/satoshi/kubernetes "
alias dskj="cd /data/gitlab.com/mintel/satoshi/kubernetes/jsonnet "
alias dsi="cd /data/gitlab.com/mintel/satoshi/infrastructure "
alias experimental="cd /data/gitlab.com/mintel/satoshi/experimental"
alias oil="cd /data/gitlab.com/mintel/satoshi/infrastructure/okta-infrastructure-live"
alias oim="cd /data/gitlab.com/mintel/satoshi/infrastructure/okta-infrastructure-modules"

###############
##  General  ##
###############

b64_decode () {
  echo "$1" | base64 -d
}

alias apti="sudo apt install "
alias aptl="sudo apt list "
alias aptlu="sudo apt list --upgradable "
alias aptr="sudo apt remove "
alias aptud="sudo apt update "
alias aptug="sudo apt upgrade "
alias authme=". ~/scripts/vault-auth.sh"
alias cmcps="ps -ef | grep -i"
alias denc="b64_decode "
alias dirs="dirs -v "
alias galias="alias | grep "
alias genv="env | grep "
alias i3config="vim ~/.config/i3/config\#\#t && yadm alt"
alias ls='ls --color=tty --group-directories-first'
alias setclip="xclip -selection c"
alias getclip="xclip -selection c -o"
alias watch="watch "

##################
##  Kubernetes  ##
##################

self_heal() {
  local STATUS; STATUS=$1; shift
  local APP_NAMES; APP_NAMES=( "$@" )
  local onJSON; onJSON='{"spec": {"syncPolicy": {"automated":{"allowEmpty": false, "prune": true, "selfHeal": true}}}}'
  local offJSON; offJSON='{"spec": {"syncPolicy": null}}'

  if [[ $STATUS == off ]]; then
      kubectl patch -n argocd app argocd-bootstrap --patch "${offJSON}" --type merge
      for APP_NAME in "${APP_NAMES[@]}"; do
        kubectl patch -n argocd app "$APP_NAME" --patch "${offJSON}" --type merge
      done
  elif [[ $STATUS == on ]]; then
    if [[ ${#APP_NAMES[@]} -eq 0 ]]; then
      kubectl patch -n argocd app argocd-bootstrap --patch "${onJSON}" --type merge
    else
      for APP_NAME in "${APP_NAMES[@]}"; do
        kubectl patch -n argocd app "$APP_NAME" --patch "${onJSON}" --type merge
      done
    fi
  else
    echo "first argument should be \"off\" or \"on\""
    exit
  fi
}

set-finalizer () {
  
  # set-finalizer FINALIZER TYPE RESOURCE1 RESOURCE2 ...
  # set-finalizer argo app cert-manager dex
  
  local FINALIZER; FINALIZER=$1; shift
  local RESOURCE_TYPE; RESOURCE_TYPE=$1; shift
  local RESOURCES; RESOURCES=( "$@" )

  case $FINALIZER in
    argo)
      json='{ "metadata": { "finalizers": ["resources-finalizer.argocd.argoproj.io"] }}'
      args=(-n argocd)
      ;;
    none)
      json='{ "metadata": { "finalizers": [] }}'
      ;;
    *)
      echo "Not supported"
      exit
      ;;
  esac

  for resource in $RESOURCES; do
    kubectl patch -p "$json" --type merge ${args[@]} $RESOURCE_TYPE $resource
  done
}

watch_pods () {
  local namespaces; namespaces=flux-apps,flux-bootstrap,${1:-image-service,portal,omni}
  watch "eval 'kubectl --namespace='{$namespaces}' get pods;'"
}

alias selfheal="self_heal "
alias setf="set-finalizer "
alias kc="kubectx "

##############################
##  Terraform / Terragrunt  ##
##############################

tgclean () {
  if [[ -z $1 ]]; then
    echo "ERROR: Must provide path"
    exit 1
  else
    find $1 -type d -regex ".*\.terra\(form\|grunt-cache\)" -exec rm -rf {} \;
  fi
}

alias tga='terragrunt apply'
alias tgap='terragrunt apply planfile'
alias tgaa='terragrunt run-all apply --terragrunt-parallelism 4'
alias tgaap='terragrunt run-all apply planfile --terragrunt-parallelism 4'
alias tgaau='terragrunt run-all apply --terragrunt-source-update --terragrunt-parallelism 4'
alias tgau='terragrunt apply --terragrunt-source-update'
alias tgd='terragrunt destroy'
alias tgda='terragrunt run-all destroy --terragrunt-parallelism 4'
alias tgdau='terragrunt run-all destroy --terragrunt-source-update --terragrunt-parallelism 4'
alias tgdu='terragrunt destroy --terragrunt-source-update'
alias tgi='terragrunt init -upgrade'
alias tgia='terragrunt run-all init -upgrade --terragrunt-parallelism 4'
alias tgo='terragrunt output'
alias tgp='terragrunt plan -out=planfile'
alias tgpa='terragrunt run-all plan -out=planfile --terragrunt-parallelism 4'
alias tgpau='terragrunt run-all plan -out=planfile --terragrunt-source-update --terragrunt-parallelism 4'
alias tgpu='terragrunt plan -out=planfile --terragrunt-source-update'
alias tgpu='terragrunt plan -out=planfile --terragrunt-source-update'
alias tgr='terragrunt refresh'
alias tgs='terragrunt show -json planfile | jq . | less'
alias tgt='terragrunt taint'

############
##  YADM  ##
############

alias y="yadm "
alias ya="yadm add"
alias yc="yadm commit -v"
alias yco="yadm checkout"
alias yd="yadm diff"
alias ydca="yadm diff --cached"
alias yfa="yadm fetch --all --prune"
alias yl="yadm pull"
alias ylog="yadm log --oneline --decorate --graph"
alias yp="yadm push"
alias yst="yadm status"
