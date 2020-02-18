docker_exec_bash () {
  docker exec -it $@ /bin/bash
}

flux_logs () {
  local instance; instance=$1
  local pod
  pod=$(kubectl get pods -n "$instance" -ocustom-columns=NAME:.metadata.name | egrep -v 'NAME|memcached')
  kubectl logs -f -n "$instance" "$pod" -c flux
}

host_exec () {
  local args; args="$@"
  echo "$args"
  local node; node=$(kubectl get pods -o json $args | jq -r .spec.nodeName)
  echo "$node"
  local ppod; ppod=$(kubectl -n kube-system get pods -l name=host-conf -o json | jq -r '.items[] | select(.spec.nodeName|contains("'"$node"'")) | .metadata.name')
  echo "$ppod"
  kubectl -n kube-system exec -it "$ppod" -- nsenter -t 1 -m -u -i -n -p
}

kubecfg_show () {
  kubecfg show $@ | vim -c 'set syntax=yaml' -
}

kubectl_exec_bash () {
  kubectl exec -it $@ /bin/bash
}

set_satoshi () {
  if [[ ! $PATH =~ "/bin/satoshi-[1-2]" ]]; then
    export PATH=~/bin/satoshi-$1:$PATH
  else
    export PATH=$(echo $PATH | sed "s/satoshi-[1-2]/satoshi-$1/")
  fi
  echo PATH=$PATH
  if [[ ! $PWD =~ "satoshi" ]]; then
    cd /data/satoshi
  fi
}

# General
alias cmcps="ps -ef | grep -i"
alias dirs="dirs -v "
alias i3config="vim ~/.config/i3/config"
alias watch="watch "
alias galias="alias | grep "
alias envgrep="env | grep "
alias authme=". ~/scripts/vault-auth.sh"
alias ds="cd /data/satoshi"
alias dsk="cd /data/satoshi/kustomize"
alias dst="cd /data/satoshi/gke-terragrunt-infrastructure"
alias dp="cd /data/python"
alias dpp="cd /data/python/portal"

# Docker
alias debash="docker_exec_bash" 
alias dpull="docker pull"
alias dpush="docker push"
alias dr="docker run -it --rm"

# Kustomize
alias kzv="kustomize build . | vim -c 'set syntax=yaml' - "
alias kza="kustomize build . | kubectl apply -f - "
alias kzb="kustomize build . "
alias kzdel="kustomize build . | kubectl delete -f - "

# Kubectl
alias fluxa="flux_logs flux-apps "
alias fluxb="flux_logs flux-bootstrap "
alias heti="host_exec "

# Directories
alias satoshi="set_satoshi"

# yadm
alias ya="yadm add"
alias yc="yadm commit -v"
alias yco="yadm checkout"
alias yd="yadm diff"
alias ydca="yadm diff --cached"
alias yfa="yadm fetch --all --prune"
alias yl="yadm pull"
alias yp="yadm push"
alias yst="yadm status"
