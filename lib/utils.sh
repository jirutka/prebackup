# Utility functions for prebackup scripts.

# Log message to stderr, or syslog if SYSLOG=yes.
# $1: log level (debug, info, notice, warning, or error)
# $2: message
log() {
	local level=$1
	local msg=$2
	[ -n "$level" ] || fail 'log: $1 must not be empty!'

	if [ "$SYSLOG" = 'yes' ]; then
		[ "$level" != 'error' ] || level='err'
		logger -t "$SYSLOG_TAG" -p "local0.$level" "$msg"

	elif [ "$level" != 'debug' ] || [ "$VERBOSE" = 'yes' ]; then
		level=$(echo "$level" | tr '[a-z]' '[A-Z]')
		printf '%s\n' "$level: $msg" >&2
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

# Check if the specified path is a directory, fail if it's not.
# $1: path to check
check_dir_exists() {
	local path="$1"

	test -d "$path" || fail "$path does not exist or not a directory!"
}

# Check if the specified path is a non-empty file, fail if it's not.
# $1: path to check
check_file_nonempty() {
	local path="$1"

	test -f "$path" || fail "$path does not exist or not a file!"
	test -s "$path" || fail "File $path is empty!"
}

# Check if the specified path is a non-empty gzip file, fail if it's not.
# $1: path to check
check_gzip_nonempty() {
	local path="$1"

	test -f "$path" || fail "$path does not exist or not a file!"

	local out; out=$(gzip -cd "$path" | cut -c1 2>/dev/null) \
		|| fail "File $path is not a valid gzip archive!"

	test -n "$out" || fail "Gzip file $path is empty!"
}

# Print value of the specified variable, or the default if empty or not defined.
# $1: variable name
# $2: default value (default: "")
getvar() {
	local name="$1"
	local default="${2:-}"

	eval "printf '%s\n' \"\${$name:-$default}\""
}

# If the specified variable is empty, then log error message and exit.
# $1: variable name
required_var() {
	if [ -z "$(getvar "$1")" ]; then
		fail "Variable $1 must not be empty!" 3
	fi
}

# Test if the first argument is equal to one of the subsequent arguments,
# i.e. if list ${@:2} includes $1.
# $1: needle
# $@: elemenets
list_has() {
	local needle="$1"; shift
	local haystack="$@"

	local i; for i in $haystack; do
		[ "$i" != "$needle" ] || return 0
	done
	return 1
}
