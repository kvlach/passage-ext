#!/bin/sh -eu

cmd_field() {
	CMD='field'

	help() {
		echo "Syntax: $PROGRAM $CMD [options] <field> <pass-name>"
		echo ''
		echo 'options:'
		echo '  -c  Move output to clipboard'
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

	[ $# -lt 1 ] && _panic

	field="$1"
	shift

	if [ $flag_menu = true ]; then
		pass_name="$("$PROGRAM" menu)"
	else
		[ $# -lt 1 ] && _panic
		pass_name="$1"
	fi

	if [ $flag_clip = true ]; then
		# `clip` comes from $PROGRAM
		clip "$(_get_field "$field" "$pass_name")" "$pass_name field $field"
	else
		_get_field "$field" "$pass_name"
	fi

}

_get_field() {
	field="$1"
	pass_name="$2"

	# TODO: check if file exists

	case "$field" in
		password)
			"$PROGRAM" show "$pass_name" | head -n 1
			;;
		url)
			# Using rev in order to support arbitrarily deep file trees
			echo "$pass_name" | rev | cut -d/ -f2 | rev
			;;
		username)
			basename "$pass_name"
			;;
		*)
			"$PROGRAM" show "$pass_name" | grep -F "$field:" | sed "s/^$field://"
			;;
	esac
}

_panic() {
	help 1>&2
	exit 1
}

cmd_field "$@"
