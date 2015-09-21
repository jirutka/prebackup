# Utility functions for prebackup scripts.

# Log message to stderr, or syslog if SYSLOG=yes.
# $1: log level (debug, info, notice, warning, or error)
# $2: message
log() {
	local level=$1
	local msg=$2
	[ -n "$level" ] || fail 'log: $1 must not be empty!'

	if [ "$SYSLOG" == 'yes' ]; then
		logger -t "$SYSLOG_TAG" -p "local0.${level/error/err}" "$msg"

	elif [[ "$level" != 'debug' || "$VERBOSE" == 'yes' ]]; then
		echo "${level^^}: $msg" >&2
	fi
}

# Log error message and exit.
# $1: message
# $2: exit code (default: 1)
fail() {
	log error "$1"
	exit ${2:-1}
}

# Log info message.
# $1: message
info() {
	log info "$1"
}

# Log debug message.
# $1: message
debug() {
	log debug "$1"
}

# If the specified variable is empty, then log error message and exit.
# $1: variable name
required-var() {
	if [ -z "${!1}" ]; then
		fail "Variable $1 must not be empty!" 3
	fi
}
