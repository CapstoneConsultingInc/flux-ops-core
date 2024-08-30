#!/usr/bin/env bash
############################################################################
#
# Performs the terraform apply associated with a flux installation.
#
############################################################################

# Exit on error
set -o errexit
set -x

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
