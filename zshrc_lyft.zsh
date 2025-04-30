# Lyft-specific aliases and functions
# Source this in ~/.zshrc

# aws
alias obsadmin="aws-okta shell zimride-admin-observability"
alias obsadminexec="aws-okta exec zimride-admin-observability -- "
alias deployadmin="aws-okta shell zimride-admin-provisioning"
alias deployadminexec="aws-okta exec zimride-admin-provisioning -- "

# aggrefest
alias aggrefest-dev="cat ~/.aggrefest/development.json | jq"
alias aggrefest-dev-all="cat ~/.aggrefest/development_all.json | jq"
alias aggrefest-stg="cat ~/.aggrefest/staging.json | jq"
alias aggrefest-stg-all="cat ~/.aggrefest/staging_all.json | jq"
alias aggrefest-prod="cat ~/.aggrefest/production.json | jq"
alias aggrefest-prod-all="cat ~/.aggrefest/production_all.json | jq"
function aggrefest-update {
    mkdir -p ~/.aggrefest
    deployadminexec aws s3 cp s3://lyft-control-iad/aggregated_manifests ~/.aggrefest/ --recursive
}

# k8s - generated from lyftkube_alias.sh
alias build-eks-0='kubectl --kubeconfig ~/.kube/clusters/build-eks-0'
alias build-eks-1='kubectl --kubeconfig ~/.kube/clusters/build-eks-1'
alias core-stg='kubectl --kubeconfig ~/.kube/clusters/core-stg'
alias core0-prd='kubectl --kubeconfig ~/.kube/clusters/core0-prd'
alias core1-prd='kubectl --kubeconfig ~/.kube/clusters/core1-prd'
alias core2-prd='kubectl --kubeconfig ~/.kube/clusters/core2-prd'
alias data-stg='kubectl --kubeconfig ~/.kube/clusters/data-stg'
alias data0-prd='kubectl --kubeconfig ~/.kube/clusters/data0-prd'
alias data1-prd='kubectl --kubeconfig ~/.kube/clusters/data1-prd'
alias infra-prd='kubectl --kubeconfig ~/.kube/clusters/infra-prd'
alias infra-stg='kubectl --kubeconfig ~/.kube/clusters/infra-stg'
alias stateful-prod='kubectl --kubeconfig ~/.kube/clusters/stateful-prod'
alias stateful-staging='kubectl --kubeconfig ~/.kube/clusters/stateful-staging'

# k8s - build kubeconfigs
function kube-config-sync {
    export KUBECONFIG=
    for kube_cluster in $HOME/.kube/clusters/*; do
        KUBECONFIG="${KUBECONFIG}:$kube_cluster"
    done
}
kube-config-sync
