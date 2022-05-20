#!/bin/sh -eu

cmd_otp() {
	CMD='otp'

	help() {
		echo "Syntax: $PROGRAM $CMD [options] <pass-name>"
		echo ''
		echo 'options:'
		echo '  -c  Move code to to clipboard'
		echo '  -m  Open pass-name selection menu'
	}

	flag_clip=false
	flag_menu=false
	while getopts cm flag; do
		case "$flag" in
			c) flag_clip=true ;;
			m) flag_menu=true ;;
			*) _panic ;;
		esac
	done
	shift $((OPTIND - 1))

	if [ $flag_menu = true ]; then
		pass_name="$("$PROGRAM" menu)"
	else
		[ $# -lt 1 ] && _panic
		pass_name="$1"
	fi

	if [ $flag_clip = true ]; then
		# `clip` comes from $PROGRAM
		clip "$(_totp "$pass_name")" "$pass_name totp code"
	else
		_totp "$pass_name"
	fi
}

_totp() {
	pass_name="$1"
	"$PROGRAM" field totp "$pass_name" | oathtool -b --totp -
}

_panic() {
	help 1>&2
	exit 1
}

cmd_otp "$@"
