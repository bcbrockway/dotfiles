host_exec () {
  local args; args="$@"
  echo "$args"
  local node; node=$(kubectl get pods -o json $args | jq -r .spec.nodeName)
  echo "$node"
  local ppod; ppod=$(kubectl -n kube-system get pods -l name=host-conf -o json | jq -r '.items[] | select(.spec.nodeName|contains("'"$node"'")) | .metadata.name')
  echo "$ppod"
  kubectl -n kube-system exec -it "$ppod" -- nsenter -t 1 -m -u -i -n -p
}

kubectl_exec_bash () {
  kubectl exec -it $@ /bin/bash
}

docker_exec_bash () {
  docker exec -it $@ /bin/bash
}

kubecfg_show () {
  kubecfg show $@ | vim -c 'set syntax=yaml' -
}

set_satoshi () {
  if [[ ! $PATH =~ "/bin/satoshi-[1-2]" ]]; then
    export PATH=~/bin/satoshi-$1:$PATH
  else
    export PATH=$(echo $PATH | sed "s/satoshi-[1-2]/satoshi-$1/")
  fi
  echo PATH=$PATH
  if [[ ! $PWD =~ "satoshi" ]]; then
    cd ~/satoshi
  fi
}

# General
alias chromep="google-chrome --user-data-dir=/home/bbrockway/.config/chrome-personal &"
alias chromew="google-chrome --user-data-dir=/home/bbrockway/.config/chrome-work &"
alias cmcps="ps -ef | grep -i"
alias gdrive="cd ~/gdrive/bobby.brockway@gmail.com"
alias i3config="vim ~/.config/i3/config"
alias watch="watch "
alias galias="alias | grep "
alias envgrep="env | grep "
alias gitlab="cd ~/git/gitlab.com "
alias github="cd ~/git/github.com "

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
alias heti="host_exec "

# Directories
alias satoshi="set_satoshi"
alias gketg="satoshi 2 && . ~/scripts/vault-auth.sh && cd ~/satoshi/gke-terragrunt-infrastructure"
