#!/bin/bash
# Author: @mikecutalo

rm -rf ~/.kube/clusters
mkdir -p ~/.kube/clusters

lyftkube get clusters -e production | cslice 0 1 | xargs -L 1 -I{} sh -c "lyftkube kubeconfig --email mcutalo@lyft.com --cluster={} > ~/.kube/clusters/{}"
lyftkube get clusters -e staging | cslice 0 1 | xargs -L 1 -I{} sh -c "lyftkube kubeconfig --email mcutalo@lyft.com --cluster={} > ~/.kube/clusters/{}"

ls ~/.kube/clusters | xargs -L 1 -I{} echo "alias {}='kubectl --kubeconfig /Users/mcutalo/.kube/clusters/{}'"
