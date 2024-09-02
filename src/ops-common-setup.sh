# shellcheck disable=SC2148
##############################################
#
# This script is not executable in and of
# itself. It is intended to be "source" from
# other scripts.
#
###############################################

# Exit on error
set -o errexit

# Short circuit this when running unit test cases.
if [ -z "$UNIT_TEST_CASE" ]; then


  # shellcheck disable=SC2046
  ROOT_SCRIPT_DIR=$(dirname $(realpath "${BASH_SOURCE[0]}"))
  
  # Bring in utility functions.
  # shellcheck disable=SC1091
  source "$ROOT_SCRIPT_DIR"/util/kube-util.sh

  # Add ops-jet source directories to the PATH. Scripts rely on this being set.
  cd "$ROOT_SCRIPT_DIR"

  # Iterate over all directories in the root script directory. The subdirectories
  # contain the scripts for the various components.
  for dir in */; do
    # Remove the trailing slash from the directory name
    dir=${dir%/}
    # Check if it's a directory (to avoid any symbolic links or other types)
    if [ -d "$dir" ]; then
      # Add the directory to the PATH
      PATH="$PATH:$(pwd)/$dir"
    fi
  done

  # Start in the workspace root directory.
  cd "$OPS_WORKSPACE_ROOT"

  # Pull in environmental configuration.
  # shellcheck disable=SC1091
  source .env
else
  # Pull in any function overrides. Must be done before the below source
  # that overrides "source" to a noop.
  if [[ -v FUNCTION_OVERRIDE ]]; then
    # shellcheck disable=SC1090
    source test/test-cases/"$FUNCTION_OVERRIDE"
  fi

  # shellcheck disable=SC1091
  source test/test-cases/helpers.bash

  # We are in a test case. Override the builtin commands. i.e. cd, source
  # shellcheck disable=SC1091
  source test/test-cases/override-builtin.bash
fi
