#!/bin/sh -eu

MENU="${PASSAGE_MENU:-dmenu}"

cmd_menu() {
	CMD='menu'

	help() {
		echo "Syntax: $PROGRAM $CMD [options]"
		echo ''
		echo 'options:'
		echo '  -c  Copy selection to clipboard'
		echo '  -h  Show this help message'
	}

	flag_clip=false
	while getopts ch flag; do
		case "$flag" in
			c) flag_clip=true ;;
			h) help && exit 0 ;;
			*) _panic ;;
		esac
	done
	shift $((OPTIND - 1))

	if [ $flag_clip = true ]; then
		selection="$(_menu)"
		[ -n "$selection" ] && clip "$selection" "'$selection'"
	else
		_menu
	fi
}

_menu() {
	"$PROGRAM" l | "$MENU"
}

_panic() {
	help 1>&2
	exit 1
}

cmd_menu "$@"
