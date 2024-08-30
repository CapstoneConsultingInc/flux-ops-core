#!/usr/bin/env bash
##################################################
#
# Performs common test setup activites.
#
##################################################

_common_setup() {
    load '../../test_helper/bats-support/load'
    load '../../test_helper/bats-assert/load'
    load '../../test_helper'

    # get the containing directory of this file
    # use $BATS_TEST_FILENAME instead of ${BASH_SOURCE[0]} or $0,
    # as those will point to the bats executable's location or the preprocessed file respectively
    PROJECT_ROOT="$(cd "$(dirname "$BATS_TEST_FILENAME")/../../.." >/dev/null 2>&1 && pwd)"
    # make executables in src/ visible to PATH
    PATH="$PATH:$PROJECT_ROOT/src"

    cd "$PROJECT_ROOT"/src

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

    cd ../

    # Set the environment variable indicting unit testing.
    # shellcheck disable=SC2034
    export UNIT_TEST_CASE="true"
}
