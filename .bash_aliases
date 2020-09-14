attach_cluster () {
  local cluster; cluster="$1"
  local region; region="$2"
  . ~/scripts/vault-auth.sh
  gcloud container clusters get-credentials "$cluster" --region "$region"
}

b64_decode () {
  echo "$1" | base64 -d
}

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

watch_pods () {
  local namespaces; namespaces=flux-apps,flux-bootstrap,${1:-image-service,portal,omni}
  watch "eval 'kubectl --namespace='{$namespaces}' get pods;'"
}

# Clusters
alias bb1="attach_cluster bb1 europe-west1"
alias eu-qa1="attach_cluster eu-qa1 europe-west1"
alias eu-prod1="attach_cluster eu-prod1 europe-west1"
alias nb1="attach_cluster nb1 europe-west1"
alias us-prod1="attach_cluster us-prod1 us-east4"
alias vault="attach_cluster vault europe-west1"

# General
alias authme=". ~/scripts/vault-auth.sh"
alias cmcps="ps -ef | grep -i"
alias denc="b64_decode "
alias dirs="dirs -v "
alias galias="alias | grep "
alias genv="env | grep "
alias i3config="vim ~/.config/i3/config\#\#t && yadm alt"
alias watch="watch "

# Directories
alias archinst="cd /data/bcbrockway/archinstall "
alias de="cd /data/gitlab.com/mintel/everest "
alias dea="cd /data/gitlab.com/mintel/everest/analytics "
alias dew="cd /data/gitlab.com/mintel/everest/web "
alias di="cd /data/gitlab.com/mintel/image-service "
alias dp="cd /data/gitlab.com/mintel/portal "
alias ds="cd /data/gitlab.com/mintel/satoshi "
alias dsc="cd /data/gitlab.com/mintel/satoshi/ci-cd "
alias dsk8="cd /data/gitlab.com/mintel/satoshi/kubernetes/k8s-bootstrap "
alias dskz="cd /data/gitlab.com/mintel/satoshi/kubernetes/kustomize "
alias dso="cd /data/gitlab.com/mintel/satoshi/onboarding "
alias dsti="cd /data/gitlab.com/mintel/satoshi/infrastructure/gke-terragrunt-infrastructure "
alias gh="cd /data/github.com "
alias ghb="cd /data/github.com/bcbrockway "
alias ghm="cd /data/github.com/mintel "

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
alias wgp="watch_pods "

# Terraform / Terragrunt
alias clean_tg='find /data -type d -regex ".*\.terra\(form\|grunt-cache\)" -exec rm -rf {} \;'

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
