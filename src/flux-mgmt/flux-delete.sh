#!/usr/bin/env bash
############################################################################
#
# Delete the flux installation from the given cluster.
#
############################################################################

# Exit on error
set -o errexit

# shellcheck disable=SC2046
SCRIPT_PATH=$(dirname $(realpath "${BASH_SOURCE[0]}"))
export SCRIPT_PATH
# shellcheck disable=SC1091
source "$SCRIPT_PATH"/../ops-common-setup.sh

CLUSTER=$1

cd "$OPS_WORKSPACE_ROOT"/ops-dc-terraform || exit 1
git fetch -a
git pull

cd flux/"$CLUSTER" || exit 0

setKubeCtx "$CLUSTER"

terraform init
terraform destroy --auto-approve

# shellcheck disable=SC2103
cd ../
git pull
rm -rf "$CLUSTER"
git add .
git commit -am "Remove flux from $CLUSTER"
git push
