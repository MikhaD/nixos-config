# `e` Home Manager Module
This module adds `e` to the user's PATH.

## Description
usage: `e [-h] [-q] [-v] <environment variable name>`

Print the value of the specified environment variable. If the variable is not set, exit with a non-zero status.

### Options
| Option        | Description                                      |
|---------------|--------------------------------------------------|
|  `-h`, `--help`    | Show this help message and exit. |
|  `-q`, `--quiet`   | Do not write anything to stdout. Exit immediately with zero status if the variable is set. |
|  `-v`, `--version` | Show the version of e and exit. |

## Completions
This module also provides bash completions for all environment variables that are set in the current scope. Completions are not case sensitive.