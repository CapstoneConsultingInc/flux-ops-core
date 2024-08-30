#!/usr/bin/env bash
############################################################################
#
# Test the flux delete script
#
############################################################################

function setup() {
    load '../../test_helper/common-setup'
    _common_setup
}

# shellcheck disable=SC2030
@test "flux delete" {

    stub git \
        "fetch -a : " \
        "pull : " \
        "pull : " \
        "add . : " \
        "commit -am \"Remove flux from test-cluster\" : " \
        "push : "

    stub rm \
        "-rf test-cluster : "

    stub terraform \
        "init : " \
        "destroy --auto-approve : "

    flux-delete.sh test-cluster
    
}

function teardown() {
    run unstub git
    run unstub rm
    run unstub terraform
    
    assert_success
    
    echo 'teardown'
}