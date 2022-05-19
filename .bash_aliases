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

alias ail="cd /data/gitlab.com/mintel/satoshi/infrastructure/aws-infrastructure-live"
alias aim="cd /data/gitlab.com/mintel/satoshi/infrastructure/aws-infrastructure-modules"
alias archinst="cd /data/bcbrockway/archinstall "
alias docs="cd /data/gitlab.com/mintel/satoshi/docs "
alias ds="cd /data/gitlab.com/mintel/satoshi "
alias dskz="cd /data/gitlab.com/mintel/satoshi/kubernetes/kustomize "
alias gh="cd /data/github.com "

############
##  Flux  ##
############

alias fluxctl="fluxctl --k8s-fwd-ns flux-apps "

###########
##  GCP  ##
###########

attach_cluster () {
  local cluster; cluster="$1"
  local region; region="$2"
  . ~/scripts/vault-auth.sh
  gcloud container clusters get-credentials "$cluster" --region "$region"
}

alias bb1="attach_cluster bb1 europe-west1"
alias cw1="attach_cluster cw1 europe-west1"
alias eu-qa1="attach_cluster eu-qa1 europe-west1"
alias eu-prod1="attach_cluster eu-prod1 europe-west1"
alias us-prod1="attach_cluster us-prod1 us-east4"
alias vault="attach_cluster vault europe-west1"

###############
##  General  ##
###############

b64_decode () {
  echo "$1" | base64 -d
}

alias apti="sudo apt update && sudo apt install "
alias aptu="sudo apt update && sudo apt upgrade"
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

flux_logs () {
  local instance; instance=$1
  echo stern -n "$instance" "$instance" -c flux$ "${@:2}"
  stern -n "$instance" "$instance" -c flux$ "${@:2}"
}

host_exec () {
  local args; args=("${@}")
  echo "${args[*]}"
  # shellcheck disable=SC2086
  local node; node=$(kubectl get pods -o json ${args[*]} | jq -r .spec.nodeName)
  echo "$node"
  local ppod; ppod=$(kubectl -n kube-system get pods -l name=host-configurator -o json | jq -r '.items[] | select(.spec.nodeName|contains("'$node'")) | .metadata.name')
  echo "$ppod"
  kubectl -n kube-system exec -it "$ppod" -- nsenter -t 1 -m -u -i -n -p
}

self_heal() {

  local STATUS; STATUS=$1; shift
  local APP_NAMES; APP_NAMES=( "$@" )
  local ENABLED

  if [[ $STATUS == off ]]; then
    ENABLED=false
  elif [[ $STATUS == on ]]; then
    ENABLED=true
  else
    echo "first argument should be \"off\" or \"on\""
    exit
  fi
  
  kubectl patch -n argocd app argocd-bootstrap -p '{"spec": {"syncPolicy": {"automated": {"selfHeal": '$ENABLED'}}}}' --type merge
  
  for APP_NAME in "${APP_NAMES[@]}"; do
    kubectl patch -n argocd app "$APP_NAME" -p '{"spec": {"syncPolicy": {"automated": {"selfHeal": '$ENABLED'}}}}' --type merge
  done
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
      json='{ "spec": { "finalizers": [] }}'
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

alias fluxa="flux_logs flux-apps "
alias fluxb="flux_logs flux-bootstrap "
alias heti="host_exec "
alias selfheal="self_heal "
alias setf="set-finalizer "
alias wgp="watch_pods "

#################
##  Kustomize  ##
#################

alias kzv="kustomize build . | vim -c 'set syntax=yaml' - "
alias kza="kustomize build . | kubectl apply -f - "
alias kzb="kustomize build . "
alias kzdel="kustomize build . | kubectl delete -f - "

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
