#!/usr/bin/env bash
############################################################################
#
# Test the flux install script.
#
############################################################################

function setup() {
    load '../../test_helper/common-setup'
    _common_setup
}

# shellcheck disable=SC2030
@test "flux install" {

    export KUBE_CONFIG_PATH="/test/kube/config"
    export GITHUB_PRIVATE_KEY="/test/private/key"

    stub git \
        "fetch -a : " \
        "pull : " \
        "pull : " \
        "add test-cluster : "\
        "commit -am \"Install flux to test-cluster.\" : " \
        "push : "
        
    stub mkdir \
        "-p test-tenant : "

    stub rm \
        "-rf test-cluster : "

    stub cp \
        "-r flux-template test-cluster : "

    stub sed \
        "echo '\/test\/kube\/config'" \
        "echo '\/test\/private\/key' " \
        "-i 's/<cluster>/test-cluster/g' main.tf : "\
        "-i 's/<private-key>/\/test\/private\/key/g' main.tf : "\
        "-i 's/<kube-config>/\/test\/kube\/config/g' main.tf : "

    stub terraform \
        "init : " \
        "apply --auto-approve : "

    flux-install.sh test-cluster
}

function teardown() {
    run unstub git
    run unstub mkdir
    run unstub rm
    run unstub cp
    run unstub sed
    run unstub terraform
    assert_success
    
    echo 'teardown'
}