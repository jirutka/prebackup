# Utility functions for prebackup scripts.

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

# Log message to stderr if VERBOSE=yes.
# $1: message
debug() {
	if [ "$VERBOSE" == 'yes' ]; then
		echo "DEBUG: $1" >&2
	fi
}

# If the specified variable is empty, then log error message and exit.
# $1: variable name
required-var() {
	if [ -z "${!1}" ]; then
		fail "Variable $1 must not be empty!" 3
	fi
}
