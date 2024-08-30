#!/usr/bin/env bash
############################################################################
#
# Performs the terraform apply associated with a flux installation.
#
############################################################################

# Exit on error
set -o errexit

function waitForFlux() {
    # Wait for flux to become operational
    TIMEOUT=300 # Timeout in seconds (5 minutes)
    START_TIME=$(date +%s)
    while true; do
        # Run the command
        flux check

        # Check the exit status
        if [ $? -eq 0 ]; then
            echo "Flux is operational"
            break
        else
            CURRENT_TIME=$(date +%s)
            ELAPSED_TIME=$((CURRENT_TIME - START_TIME))
            if [ $ELAPSED_TIME -ge $TIMEOUT ]; then
                echo "Timeout reached. Not all pods are running."
                exit 1
            fi
            # If the command fails, wait for 10 seconds and try again
            echo "Flux not ready. Retrying in 10 seconds..."
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

cd "$OPS_WORKSPACE_ROOT"/ops-infra || exit 1
git fetch -a
git pull

cd flux

# Start clean.
set +e
rm -rf "$CLUSTER"
set -e

cp -r flux-template "$CLUSTER"
cd "$CLUSTER" || exit 0

ESCAPED_KUBE_CONFIG_PATH=$(echo "$KUBE_CONFIG_PATH" | sed 's/\//\\\//g')

ESCAPED_GITHUB_PRIVATE_KEY=$(echo "$GITHUB_PRIVATE_KEY" | sed 's/\//\\\//g')
sed -i "s/<cluster>/$CLUSTER/g" main.tf
sed -i "s/<private-key>/$ESCAPED_GITHUB_PRIVATE_KEY/g" main.tf
sed -i "s/<kube-config>/$ESCAPED_KUBE_CONFIG_PATH/g" main.tf

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