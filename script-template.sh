#!/usr/bin/env bash
############################################################################
#
# Replace with something brillant and insightful regarding the script's
# functionality.
#
############################################################################

# Exit on error
set -o errexit

# shellcheck disable=SC2046
SCRIPT_PATH=$(dirname $(realpath "${BASH_SOURCE[0]}"))
export SCRIPT_PATH
# shellcheck disable=SC1091
source "$SCRIPT_PATH"/../ops-common-setup.sh