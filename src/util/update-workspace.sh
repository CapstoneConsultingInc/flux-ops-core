#!/usr/bin/env bash
#################################################################
#
# Update the repositories in a workspace.
#
#################################################################

# Exit on error
set -o errexit

OPS_INFRA_DIR="$OPS_WORKSPACE_ROOT"/ops-infra
OPS_CORE_DIR="$OPS_WORKSPACE_ROOT"/ops-jet

# Check if the ops-infra directory exists
if [ ! -d "$OPS_INFRA_DIR" ]; then
    cd "$OPS_WORKSPACE_ROOT"
    git clone git@github.com:CapstoneConsultingInc/ops-infra.git
else
    cd "$OPS_INFRA_DIR"; git pull
fi

cd "$OPS_CORE_DIR"; git pull