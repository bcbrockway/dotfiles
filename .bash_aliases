docker_exec_bash () {
  docker exec -it $@ /bin/bash
}

flux_logs () {
  local instance; instance=$1
  echo stern -n "$instance" "$instance" -c flux$ "${@:2}"
  stern -n "$instance" "$instance" -c flux$ "${@:2}"
}

host_exec () {
  local args; args="$@"
  echo "$args"
  local node; node=$(kubectl get pods -o json $args | jq -r .spec.nodeName)
  echo "$node"
  local ppod; ppod=$(kubectl -n kube-system get pods -l name=host-configurator -o json | jq -r '.items[] | select(.spec.nodeName|contains("'$node'")) | .metadata.name')
  echo "$ppod"
  kubectl -n kube-system exec -it "$ppod" -- nsenter -t 1 -m -u -i -n -p
}

kubecfg_show () {
  kubecfg show $@ | vim -c 'set syntax=yaml' -
}

kubectl_exec_bash () {
  kubectl exec -it $@ /bin/bash
}

# General
alias authme=". ~/scripts/vault-auth.sh"
alias cmcps="ps -ef | grep -i"
alias dirs="dirs -v "
alias envgrep="env | grep "
alias galias="alias | grep "
alias i3config="vim ~/.config/i3/config\#\#t && yadm alt"
alias watch="watch "

# Directories
alias archinst="cd /data/bcbrockway/archinstall"
alias ds="cd /data/satoshi"
alias dsc="cd /data/satoshi/ci-cd"
alias dsk8="cd /data/satoshi/kubernetes/k8s-bootstrap"
alias dskz="cd /data/satoshi/kubernetes/kustomize"
alias dsti="cd /data/satoshi/infrastructure/gke-terragrunt-infrastructure"
alias dp="cd /data/python"
alias dpe="cd /data/python/experimental"
alias dpp="cd /data/python/portal"

# Docker
alias debash="docker_exec_bash" 
alias dpull="docker pull"
alias dpush="docker push"
alias dr="docker run -it --rm"

# Flux
alias fluxctl="fluxctl --k8s-fwd-ns flux-apps "

# Kustomize
alias kzv="kustomize build . | vim -c 'set syntax=yaml' - "
alias kza="kustomize build . | kubectl apply -f - "
alias kzb="kustomize build . "
alias kzdel="kustomize build . | kubectl delete -f - "

# Kubectl
alias fluxa="flux_logs flux-apps "
alias fluxb="flux_logs flux-bootstrap "
alias heti="host_exec "

# yadm
alias y="yadm "
alias ya="yadm add"
alias yc="yadm commit -v"
alias yco="yadm checkout"
alias yd="yadm diff"
alias ydca="yadm diff --cached"
alias yfa="yadm fetch --all --prune"
alias yl="yadm pull"
alias yp="yadm push"
alias yst="yadm status"
