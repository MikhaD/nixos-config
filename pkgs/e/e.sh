#!/usr/bin/env bash
VERSION="<REPLACED IN INSTALL PHASE>"

usage="usage: e [-h] [-q] [-v] <environment variable name>"
if [[ -z $1 ]]; then # check if the value of $1 exists as an environment variable
	echo $usage
	exit 1
fi
case $1 in
	-h|--help)
		echo $usage
		echo
		echo "Print the value of the specified environment variable. If the variable is not set, exit with a non-zero status."
		echo
		echo "options:"
		echo "  -h, --help     Show this help message and exit."
		echo "  -q, --quiet    Do not write anything to stdout. Exit immediately with zero status if the variable is set."
		echo "  -v, --version  Show the version of e and exit."
		echo
		echo "e version $VERSION"
		;;
	-q|--quiet)
		if [[ -z $2 ]]; then
			echo $usage
			exit 1
		fi
		[[ -v $2 ]]
		exit $?
		;;
	-v|--version)
		echo "e version $VERSION"
		;;
	*)
		printenv $1
		exit $?
		;;
esac