#!/usr/bin/env bash
###############################################################################
# Copyright (c) 2018 Red Hat Inc
#
# See the NOTICE file(s) distributed with this work for additional
# information regarding copyright ownership.
#
# This program and the accompanying materials are made available under the
# terms of the Eclipse Public License 2.0 which is available at
# http://www.eclipse.org/legal/epl-2.0
#
# SPDX-License-Identifier: EPL-2.0
###############################################################################
die() { echo "$*" 1>&2 ; exit 1; }
need() {
  which "$1" &>/dev/null || die "Binary '$1' is missing but required"
}
# checking pre-reqs
need "jq"
need "curl"
need "kubectl"
NAMESPACE="$1"
echo $NAMESPACE
shift
if [ "$NAMESPACE" = "" ]; then
   die "Missing arguments: kill-ns <namespace>"
fi
echo "This script is going to force-kill everything in the namespace $NAMESPACE"
echo
echo "CHECK YOU HAVE THE RIGHT KUBE-CONTEXT CONFIGURED!"
echo "CHECK YOU HAVE THE RIGHT KUBE-CONTEXT CONFIGURED!"
echo "CHECK YOU HAVE THE RIGHT KUBE-CONTEXT CONFIGURED!"
echo
echo "Sleeping for 5 seconds (ctcl-c to exit now)"
sleep 5
kubectl proxy &>/dev/null &
PROXY_PID=$!
killproxy () {
  kill $PROXY_PID
}
trap killproxy EXIT
kubectl get namespace "$NAMESPACE" -o json | jq 'del(.spec.finalizers[] | select("kubernetes"))' | curl -s -k -H "Content-Type: application/json" -X PUT -o /dev/null --data-binary @- http://localhost:8001/api/v1/namespaces/$NAMESPACE/finalize && echo "Killed namespace: $NAMESPACE"
# proxy will get killed by the trap
