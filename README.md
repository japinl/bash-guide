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
