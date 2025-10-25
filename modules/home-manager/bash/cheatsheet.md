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

> [!NOTE]
> The `shift [n]` command can be used to shift the positional parameters, ie.
> rename the positional parameters \$N+1,\$N+2 ... to \$1,\$2 ...
> If N is not given, it is assumed to be 1.
> Fails if N is negative or greater than the number of positional parameters ($#).

## If statements
If statements in bash have the following syntax:
```bash
if <condition>; then
	# code to execute if condition is true
elif <another condition>; then
	# code to execute if another condition is true
else
	# code to execute if none of the above conditions are true
fi
```
Conditions can be anything that returns a status code (0 for true, non-zero for false).

If you have looked at a bash script you will have likely noticed that many conditions appear to be enclosed in single or double square brackets.

### Single square brackets `[]`
`[` is actually a command, which is equivalent to the `test` command. The only difference is that `[` requires a closing `]` as the last argument.

Because of this you can learn the syntax required for `[` conditions by looking at the man page for `test`.

### Double square brackets `[[]]`
`[[` is a bash keyword that is more powerful than `[` and `test`. It supports additional features like pattern and regex matching. It also does not require bash variables to be quoted in order to work correctly, nor does it require brackets or less than and greater than signs to be escaped. It also allows for logical operators like `&&` and `||` to be used within the condition.

### Operators
The logical operators used in `[` and `[[` conditions are similar but not identical. A list of differences can be found [here](https://mywiki.wooledge.org/BashFAQ/031). This cheat sheet uses the ones for `[[`.

#### String Comparison
| Operator | Description | Example |
|----------|-------------|---------|
| `=` or `==` | 0 if the strings match | `[[ $a = $b ]]` |
| `!=`     | 0 if the strings do not math | `[[ $a != $b ]]` |
| `=~`	   | 0 if the string on the left matches the regex on the right. The array variable `BASH_REMATCH` contains the portion of the string that matched the regular expression. 0 contains the portion that matched the entire regex. The remaining indices contain the corresponding parenthesized sub expressions. | `[[ $a =~ ^[0-9]+$ ]]` |
INCOMPLETE

#### Numeric Comparison
| Operator | Description | Example |
|----------|-------------|---------|


#### Files and Directories
| Operator | Description | Example |
|----------|-------------|---------|

[Reference Manual](https://www.gnu.org/software/bash/manual/bash.html#index-_005b_005b)
## Loops

## Case statements
https://www.howtogeek.com/766978/how-to-use-case-statements-in-bash-scripts/

## Data structures
https://bashcommands.com/bash-data-structures
https://bashcommands.com/bash-declare

### Arrays

