#!/bin/sh -eu

EXT='age'

cmd_l() {
	# `$PREFIX` comes from $PROGRAM
	cd "$PREFIX"
	find . -type f -name "*.$EXT" | sed "s/^..//;s/\.$EXT$//" | sort
}

cmd_l  "$@"
