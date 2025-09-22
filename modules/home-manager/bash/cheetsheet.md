# Bash Cheat Sheet
This is a quick reference cheat sheet for bash scripting. You can find the entire bash reference manual [here](https://www.gnu.org/software/bash/manual/bash.html).
## Special variables
Special bash parameters (variables with special meaning):
| Variable | Description |
|----------|-------------|
| `$*`     | All arguments passed to the script as a single word |
| `$@`     | All arguments passed to the script as separate words |
| `$#`     | Number of arguments passed to the script |
| `$?`     | Exit status of the last command |
| `$-`     | Current options set for the shell |
| `$$`     | Process ID of the current shell |
| `$!`     | Process ID of the last background command |
| `$0`     | Name of the script |
| `$1`, `$2`, ... | The first, second, etc. argument passed to the script |

[reference manual](https://www.gnu.org/software/bash/manual/bash.html#Special-Parameters)

## If statements
If statements in bash have the following syntax:
```bash
if [ condition ]; then
	# code to execute if condition is true
elif [ another_condition ]; then
	# code to execute if another_condition is true
else
	# code to execute if none of the above conditions are true
fi
```
Conditions can be anything that returns a status code (0 for true, non-zero for false). A lot of conditions appear to be enclosed in single or double square brackets

### TODO: Explain the difference
https://mywiki.wooledge.org/BashFAQ/031

https://stackoverflow.com/questions/3427872/whats-the-difference-between-and-in-bash

## Loops

## Data structures

### Arrays

