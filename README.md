# Bash Guide Notes

My reading notes for *Bash Guide for Beginners*.

## Overview of set debugging options

 Short notation | Long notation  | Result
:---------------|:---------------|:-----------
 set -f         | set -o noglob  | Disable file name generation using metacharacters (globbing).
 set -v         | set -o verbose | Prints shell inputs lines as they are read.
 set -x         | set -o xtrace  | Print command traces before executing command.

The dash is used to activate a shell option and a plus to deactivate it.

## Variables

### Type of variables

 type             | brief
:-----------------|:-------
 Global variables | Global variables and environment variables are available in all shells.
 Local variables  | Local variables are only available in the current shell.

The **env** or **printenv** commands can be used to display environment variables. And the **set** built-in command without any options will display a list of all variables (including environment variables) and functions.

Variables are *case sensitive* and *capitalized* by default. Giving local variables a *lowercase* name is a convention which is sometimes applied. Variables can also contain digits, but a name starting with a digit is not allowed:

``` shell
japin@localhost:~/bash-guide$ export 1number=1
-bash: export: `1number=1': not a valid identifier
```

To set a variable in the shell, use

``` shell
VARNAME="value"
```

**NOTE:** Putting spaces around the equal sign will cause errors. It is a good habit to quote content stings when assigning values to variables: this will reduce the chance that you make errors.

Some examples using upper and lower cases, numbers and spaces:

``` shell
japin@localhost:~/bash-guide$ MYVAR1="2"
japin@localhost:~/bash-guide$ echo $MYVAR1
2
japin@localhost:~/bash-guide$ first_name="Japin"
japin@localhost:~/bash-guide$ echo $first_name
Japin
japin@localhost:~/bash-guide$ full_name="Japin Li"
japin@localhost:~/bash-guide$ echo $full_name
Japin Li
japin@localhost:~/bash-guide$ MYVAR-2="2"
MYVAR-2=2: command not found
japin@localhost:~/bash-guide$ MYVAR1 ="2"
MYVAR1: command not found
japin@localhost:~/bash-guide$ MYVAR1= "2"
2: command not found
```

### Exporting variables

A variable created like the ones in the example above is only available to the current shell. It is a local variable: child process of the current shell will not be aware of this variable. In order to pass variable to a subshell, we need to *export* them using **export** built-in command. Variables that are exported are referred to as environment variables. Setting and exporting is usually done in one step:

``` shell
export VARNAME="value"
```

**NOTE:** A subshell can change variables it inherited from the parent, but the changes made by the child don't affect the parent. For example:

``` shell
japin@localhost:~/bash-guide$ full_name="Japin Li"
japin@localhost:~/bash-guide$ bash
japin@localhost:~/bash-guide$ echo $full_name

japin@localhost:~/bash-guide$ exit
exit
japin@localhost:~/bash-guide$ export full_name
japin@localhost:~/bash-guide$ bash
japin@localhost:~/bash-guide$ echo $full_name
Japin Li
japin@localhost:~/bash-guide$ export full_name="Hello world"
japin@localhost:~/bash-guide$ echo $full_name
Hello world
japin@localhost:~/bash-guide$ exit
exit
japin@localhost:~/bash-guide$ echo $full_name
Japin Li
```

### Special parameters

 Character | Definition
:----------|:-------------
 $*        | Expands to the positional parameters, starting from one. When the expansion occurs within double quotes, it expands to a single word with the value of each parameter separated by the first character of the IFS special variable.
 $@        | Expands to the positional parameters, starting from one. When the expansion occurs within double quotes, each parameter expands to a separated word.
 $#        | Expands to the number of positional parameters in decimal.
 $?        | Expands to the exit status of the most recently executed foreground pipepline.
 $-        | A hyphen expands to the current option flags as specified upon invocaton, by the **set** built-in command, or those set by the shell itself (such as the -i).
 $$        | Expands to the process ID of the shell.
 $!        | Expands to the process ID of the most recently executed background (asynchronous) command.
 $0        | Expands to the name of the shell or shell script.
 $_        | The underscore variable is set at shell startup and contains the absolute file name of the shell or script being executed as passed in the argument list. Subsequently, it expands to the last argument to the previous command, after expansion. It is also set to the full pathname of each command executed and placed in the environment exported to that command. When checking mail, this parameter holds the name of the mail file.

### Quotes

 Type               | Brief
:-------------------|:---------
 Single quotes ('') | Used to preserve the literal value of each character enclosed within the quotes. A single quote may not occur between single quotes, even when preceded by a backslash.
 Double quotes ("") | Used to preserve the literal value of all characters, except for the dollar sign, the backticks (backward single quotes, ``) and the backslash. The dollar sign and the backticks retain their special meaning within the double quotes. The backslash retains its meaning only when followed by dollor, backtick, double quote, backslash or newline.
 
 ### Shell expansion
 
 1. **Brace expansion** - Brace expansion is a mechanism by which arbitray strings may be generated. The form of patterns to be barac-expansion is an optional *PREAMBLE*, followed by a series of comman-separated strings between a pair of braces, followed by an optional *POSTSCRIPT*. The *PREAMBLE* is prefixed to each string contained within the braces, and the *POSTSCRIPT* is then appended to each resulting string, expanding left to right. Brace expansions may be nested. 
    Brace expansion is performed before any other expansions, and any characters special to other expansions are preserved in the result. To avoid conflicts with parameter expansion, the string "${" is not considered eligible for brace expansion.
 2. **Tilde expansion** - If a word begins with an unquoted tilde character ("\~"), all of the characters up to the first unquoted slash (or all characters, if there is no unquoted slash) are considered a *tilde-prefix*. 
    If the tilde-prefix is "\~+", the value of the shell variable *PWD* replaces the tilde-prefix. If the tilde-prefix is "\~-", the value of shell variable *OLDPWD*, if it is set, is substituted.
3. **Shell parameter and variable expansion** - The "$" character introduces parameter expansion, command substitution, or arithmetic expansion. The parameter name or symbol to be expanded may be enclosed in braces, which are optional but serve to protect the variable to be expanded from characters immediately following it which could be interpreted as part of the name.
   The basic form of parameter expansion is "${PARAMETER}". The value of "PARAMETER" is substituted. The braces are required when "PARAMETER" is a positional parameter with more than one digit, or when "PARAMETER" is followed by a character that is not to be interpreted as part of its name. If the first character of "PARAMETER" is an exclamation point ("!"), Bash uses the value of the variable formed from the rest of "PARAMETER" as the name of the variable; this variable is then expanede and the value is used in the rest of the substitution, rather the value of "PARAMETER" itself. This is known as *indirect expansion*. For example,
   ```
   japin@localhost:~/bash-guide$ hello=world
   japin@localhost:~/bash-guide$ hi=hello
   japin@localhost:~/bash-guide$ echo ${hi}
   hello
   japin@localhost:~/bash-guide$ echo ${!hi}
   world
   ```
   The following construct allows for creation of the named variable if it does not yet exist:
   ```
   ${VAR:=value}
   ```
   However, special parameters, among others the positional parameters, may not be assigned this way.
4. **Command substitution** - Command substitution allows the output of a command to replace the command itself. Command substitution occurs when a command is enclosed like this:
   ```
   $(command)
   ```
   or like this using backticks:
   ```
   `command`
   ```
   Bash performs the expansion by executing COMMAND and replacing the command substitution with the standard output of the command, with any trailing newlines deleted.
   Command substitutions may be nested. To nest when using the backquoted form, escape the inner backticks with backslashes.
   *If the subsitution appears within double quotes, word splitting and file name expansion are not performed on the results. (What?)*
5. **Arithmetic expansion** - Arithmetic expansion allows the evaluation of an arithmetic expression and the substitution of the result. The format for arithmetic expression is:
   ```
   $((EXPRESSION))
   ```
   The expression is treated as if it were within double quotes, but a double quote inside the parentheses is not treated specially. All tokens in the expression undergo parameter expansion, command substitution, and quote removal. Arithmetic substitutions may be nested.
   Evaluation of arithmetic expression is done in fixed-width integers with no check for overflow - although division by zero is trapped and recognized as an error. The operators are roughly the same as in the C programming language. In order of decreasing precedence, the list looks like this:
   
    Operator            | Meaning
   :--------------------|:---------------
    VAR++ and VAR--     | variable post-increment and post-decrement
	++VAR and --VAR     | variable pre-increment and pre-decrement
	\- and +            | unary minus and plus
	! and ~             | logical and bitwise negation
	\*\*                | exponentiation
	\*, / and %         | multiplication, division, and remainder
	\+ and -            | addition, subtraction
	<< and >>           | left and right bitwise shifts
	<=, >=, < and >     | comparison operators
	== and !=           | equality and inequality
	&                   | bitwise AND
	^                   | bitwise exclusive OR
	\|                  | bitwise OR
	&&                  | logical AND
	\|\|                | logical OR
	expr ? expr : expr  | conditional evaluation
	=, \*=, /=, %=, +=, -=, <<=, >>=, &=, ^= and \|= | assignments
	,                   | separator between expression
	
   Constans with a leading 0 (zero) are interpreted as octal numbers. A leading "0x" or "0X" denotes hexadecimal.
   Wherever possible, Bash users should try to use the syntax with square brackets:
   ```
   $[EXPRESSION]
   ```
   However, this will only calculate the result *EXPRESSION*, and do no tests.
6. **Process substitution** - Process substitution is supported on systems that support named pipes (FIFOs) or the */dev/fd* method of naming open files. It takes the form of
   ```
   <(LIST)
   ```
   or
   ```
   >(LIST)
   ```
   The process *LIST* is run its input or output connected to a FIFO or some file in */dev/fd*. If the ">(LIST)" form is used, writing to the file will provide input for *LIST*. If the "<(LIST)* form is used, the file passed as an argument should be read to obtain the output of *LIST*. *Note that no space may appear between the < or > signs and the left parenthesis, otherwise the construct would be interpreted as a redirection.
   When available, process substitution is performed simultaneously with parameter and variable expansion, command substitution, and arithmetic expansion.
7. **Word splitting** - The shell scans the results of parameter expansion, command substitution, and arithmetic expansion that did not occur within double quotes for word splitting.
   The shell treats each character of $IFS as a delimiter, and splits the results of the other expansions into words on these characters.

8. **File name expansion** - After word splitting, unless the *-f* option has been set, Bash scans each word for characters "*", "?", and "[". If one of these characters appears, then the word is regarded as a *PATTERN*, and replaced with an alphabetically sorted list of file names matching the pattern.
