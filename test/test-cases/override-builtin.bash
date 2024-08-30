#!/usr/bin/env bash
###################################################################
#
#  BASH builtin commands cannot be stubbed out with the bats
#  framework. The commands are not called based on PATH. They are
#  builtin to the OS. This technique overrides those commands.
#
###################################################################
function source() {
    return
}

function cd() {
    return
}

function wait() {
    return
}