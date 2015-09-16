# Utility functions for backup hooks.

# Log error message and exit.
# $1: message
# $2: exit code (default: 1)
fail() {
	echo "ERROR: $1" >&2
	exit ${2:-1}
}

# Log info message.
# $1: message
info() {
	echo "$1" >&2
}

# Log message to stderr if verbose=yes.
# $1: message
debug() {
	if [ "$verbose" == 'yes' ]; then
		echo "DEBUG: $1" >&2
	fi
}

# If the specified variable is empty, then fail with an error message.
# $1: variable name
required-var() {
	if [ -z "${!1}" ]; then
		fail "Variable $1 must not be empty!" 3
	fi
}
