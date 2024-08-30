# Define an assert function
assert() {
    if ! "$@"; then
        # shellcheck disable=SC2145
        echo "Assertion failed: ${@}"
        exit 1
    fi
}