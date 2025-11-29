# `e`

## Description

`e` is a utility to print the value of the specified environment variable. It also provides case insensitive bash completions for all environment variables.

usage: `e [-h] [-q] [-v] <environment variable name>`

Print the value of the specified environment variable. If the variable is not set, exit with a non-zero status.

### Options

| Option            | Description                                                                                |
| ----------------- | ------------------------------------------------------------------------------------------ |
| `-h`, `--help`    | Show this help message and exit.                                                           |
| `-q`, `--quiet`   | Do not write anything to stdout. Exit immediately with zero status if the variable is set. |
| `-v`, `--version` | Show the version of e and exit.                                                            |
