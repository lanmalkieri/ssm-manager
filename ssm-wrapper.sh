#!/usr/bin/env bash
#---------------------------------------------------#  
# This script is designed around managing configs in 
# SSM via local YML files that are managed through
# source control. On commit this script is run against 
# dev and prod accounts
#---------------------------------------------------#  
set -e

setup(){
    environment=$1

    if [[ -z ${environment} ]]; then
        echo "Must pass environment variable [dev or prod]"
        exit 1
    fi

    if ! type -a ssm-diff &>/dev/null; then
        echo "Missing ssm-diff"
        exit 1
    fi

    if [[ ${environment} == dev ]]; then
        working_files=(development.yml staging.yml global.yml)
    elif [[ ${environment} == prod ]]; then
        working_files=(prod.yml global)
    fi
}
setup_params(){
    for file in ${working_files[@]}; do
        local_file="configs/${file}"

        if [[ -f ${local_file} ]]; then
            ssm-diff -p /${environment} -f ${local_file} plan 
            ssm-diff -p /${environment} -f ${local_file} apply
        else
            echo "Missing config file ${local_file}"
            exit 1
        fi
    done
}
main(){
    setup "$@"
    setup_params
}

main "$@"
