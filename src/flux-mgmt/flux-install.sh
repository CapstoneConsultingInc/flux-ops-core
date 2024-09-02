#!/usr/bin/env bash
############################################################################
#
# Performs the terraform apply associated with a flux installation.
#
############################################################################

# Exit on error
set -o errexit

# This function is intended to be used after flux has been installed on 
# a k8s cluster. The terraform used to install flux succeeds when flux
# has been installed. This functions verifies flux is functional as well.
function waitForFlux() {
    # Wait for flux to become operational
    TIMEOUT=300 # Timeout in seconds (5 minutes)
    START_TIME=$(date +%s)
    while true; do

        # Check the status of flux via the flux cli
        if flux check; then
            echo "Flux is operational"
            break
        else
            CURRENT_TIME=$(date +%s)
            ELAPSED_TIME=$((CURRENT_TIME - START_TIME))
            if [ $ELAPSED_TIME -ge $TIMEOUT ]; then
                echo "ERROR: Timeout reached waiting for flux to become operational." >&2
                exit 1
            fi
            # If the command fails, wait for 10 seconds and try again
            echo "Flux check failed. Retrying in 10 seconds..."
            sleep 10
        fi
    done
}

# shellcheck disable=SC2046
SCRIPT_PATH=$(dirname $(realpath "${BASH_SOURCE[0]}"))
export SCRIPT_PATH
# shellcheck disable=SC1091
source "$SCRIPT_PATH"/../ops-common-setup.sh

CLUSTER=$1

cd "$OPS_WORKSPACE_ROOT"/ops-dc-terraform || exit 1
git fetch -a
git pull

cd flux

# Start clean.
set +e
rm -rf "$CLUSTER"
set -e

cp -r flux-template "$CLUSTER"
cd "$CLUSTER" || exit 0

# These environment variables contain paths. These paths must
# be escaped to use in a sed command.
ESCAPED_KUBECONFIG=$(echo "$KUBECONFIG" | sed 's/\//\\\//g')
ESCAPED_GITHUB_PRIVATE_KEY=$(echo "$GITHUB_PRIVATE_KEY" | sed 's/\//\\\//g')
# Perform the token replacements for this installation.
sed -i "s/<cluster>/$CLUSTER/g" main.tf
sed -i "s/<private-key>/$ESCAPED_GITHUB_PRIVATE_KEY/g" main.tf
sed -i "s/<kube-config>/$ESCAPED_KUBECONFIG/g" main.tf

# Set the kubernetes context for the given cluster.
setKubeCtx "$CLUSTER"

terraform init
terraform apply --auto-approve

# shellcheck disable=SC2103
cd ../
git pull
git add "$CLUSTER"
git commit -am "Install flux to $CLUSTER."
git push

# Wait for flux to become operational
waitForFlux