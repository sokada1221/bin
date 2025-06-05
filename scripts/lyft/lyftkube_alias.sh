#!/bin/bash
# Author: @mikecutalo

EMAIL_ADDRESS='sokada@lyft.com'

rm -rf ~/.kube/clusters
mkdir -p ~/.kube/clusters

#lyftkube get clusters -e production | awk 'NR>1 {print $1}' | xargs -L 1 -I{} sh -c "lyftkube kubeconfig --email ${EMAIL_ADDRESS} --cluster={} > ~/.kube/clusters/{}"
#lyftkube get clusters -e staging | awk 'NR>1 {print $1}' | xargs -L 1 -I{} sh -c "lyftkube kubeconfig --email ${EMAIL_ADDRESS} --cluster={} > ~/.kube/clusters/{}"

lyftkube get clusters | awk 'NR>2 {print $1}' | xargs -L 1 -I{} sh -c "lyftkube kubeconfig --email ${EMAIL_ADDRESS} --cluster={} > ~/.kube/clusters/{}"

ls ~/.kube/clusters | xargs -L 1 -I{} echo "alias {}='kubectl --kubeconfig ~/.kube/clusters/{}'"
