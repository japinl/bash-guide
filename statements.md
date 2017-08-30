# Statements

The most compact syntax of the **if** command is:

```
if TEST-COMMANDS; then CONSEQUENT-COMMANDS; fi
```

The **TEST-COMMANDS** list is executed, and if its return status is *zero*. The **CONSEQUENT-COMMANDS** list is executed. The return status is the exit status of the last command executed, or zero if no condition tested true.

The **TEST-COMMANDS** often involves numerical or string comparison tests, but it can also be any command that returns a status of zero when it succeeds and some other status when it fails.

The table below contains an overview of the so-called "primaries" that make up the **TEST-COMMANDS** command or list of commands.

 Primary     | Meaning
:------------|----------
 [ -a FILE ] | True if *FILE* exists.
 [ -b FILE ] | True if *FILE* exists and is a block-special file.
 [ -c FILE ] | True if *FILE* exists and is a character-special file.
 [ -d FILE ] | True if *FILE* exists and is a directory.
 [ -e FILE ] | True if *FILE* exists.
 [ -f FILE ] | True if *FILE* exists and is a regular file.
 [ -g FILE ] | True if *FILE* exists and its *SGID* bit is set.
 [ -h FILE ] | True if *FILE* exists and is a symbolic link.
 [ -k FILE ] | True if *FILE* exists and its sticky bit is set.
 [ -p FILE ] | True if *FILE* exists and is a named pipe (FIFO).
 [ -r FILE ] | True if *FILE* exists and is readable.
 [ -s FILE ] | True if *FILE* exists and has a size greater than zero.
 [ -t FD ]   | True if file descriptor *FD* is open and refers to a terminal.
 [ -u FILE ] | True if *FILE* exists and its *SUID* (set user *ID*) bit is set.
 [ -w FILE ] | True if *FILE* exists and is writable.
 [ -x FILE ] | True if *FILE* exists and is executable.
 [ -O FILE ] | True if *FILE* exists and is owned by the effective user *ID*.
 [ -G FILE ] | True if *FILE* exists and is owned by the effective group *ID*.
 [ -L FILE ] | True if *FILE* exists and is a symbolic link.
 [ -N FILE ] | True if *FILE* exists and has been modified since it was last read.
 [ -S FILE ] | True if *FILE* exists and is a socket.
 [ FILE1 -nt FILE2 ] | True if *FILE1* has been changed more recently than *FILE2*, or if *FILE1* exists and *FILE2* does not.
 [ FILE1 -ot FILE2 ] | True if *FILE1* is order than *FILE2*, or is *FILE2* exists and *FILE1* does not.
 [ FILE1 -ef FILE2 ] | True if *FILE1* and *FILE2* refer to the same device and inode numbers.
 [ -o OPTIONNAME ]   | True if shell option "*OPTIONNAME*" is enabled.
 [ -z STRING ]       | True of the length if "*STRING*" is zero.
 [ -n STRING ] or [ STRING ] | True if the length of "*STRING*" is non-zero.
 [ STRING1 == STRING2 ]      | True if the strings are equal. "=" may be used instead of "==" for strict POSIX compliance.
 [ STRING1 != STRING2 ]      | True if the strings are not equal.
 [ STRING1 < STRING2 ]       | True if "*STRING1*" sorts before "*STRING2*" lexicographically in the current locale.
 [ STRING1 > STRING2 ]       | True if "*STRING1*" sorts after "*STRING2*" lexicographically in the current locale.
 [ ARG1 OP ARG2 ]            | "*OP*" is one of *-eq*, *-ne*, *-lt*, *-le*, *-gt* or *-ge*. These arithmetic binary operators return true if "*ARG1*" is equal to, not equal to, less then, less than or equal to, greater than, or greater than or equal to "*ARG2*", respectively. "*ARG1*" and "*ARG2*" are integers.

Expressions may be combined using the following operators, listed in decreasing order of precedence:

 Operation         | Effect
:------------------|:-----------
 [ ! EXPR ]        | True if *EXPR* is false.
 [ ( EXPR ) ]      | Returns the value of *EXPR*. This may be used to override the normal precedence of operators.
 [ EXPR1 -a EXPR2 ] | True if both *EXPR1* and *EXPR2* are ture.
 [ EXPR1 -o EXPR2 ] | True if either *EXPR1* or *EXPR2* is ture.

The **CONSEQUENT-COMMANDS** list that follows the **then** statement can be any valid UNIX command, any executable program, any executable shell script or any shell statement, with the exception of the closing **fi**.

**NOTE:** Contray to *[*, *[[* prevents word splitting of variable values. So, if `VAR="var with spaces"`, you do not need to double quote `$VAR` in a test - eventhough using quotes remains a good habit. Also, *[[* prevents pathname expansion, so literal strings with wildcards do not try to expand to filenames. Using *[[*, *==* and *!=* interpret strings to the right as shell glob patterns to be matched against the value to the left, for instance: `[[ "value" == val* ]]`.

There are more advanced **if** usage.

```
if TEST-COMMANDS; then
    CONSEQUENT-COMMANDS;
else
    ALTERNATE-CONSEQUENT-COMMANDS;
fi
```

Like the **CONSEQUENT-COMMANDS** list following the **then** statement, the **ALTERNATE-CONSEQUENT-COMMANDS** list following the **else** statement can hold any UNIX-style command that return an exit status.

This is the full form of the **if** statement:

```
if TEST-COMMANDS; then
    CONSEQUENT-COMMANDS;
elif MORE-TEST-COMMANDS; then
    MORE-CONSEQUENT-COMMANDS;
else
    ALTERNATE-CONSEQUENT-COMMANDS;
fi
```
The **TEST-COMMANDS** list is executed, and if its return status is zero, the **CONSEQUENT-COMMANDS** list is executed. if **TEST-COMMANDS** returns a non-zero status, each **elif** list is executed in turn, and if its exit status is zero, the corresponding **MORE-CONSEQUENT-COMMANDS** is executed and the command completes. if **else** is followed by an **ALTERNATE-CONSEQUENT-COMMANDS** list, and the final command in the final **if** or **elif** clause has a non-zero exit status, then **ALTERNATE-CONSEQUENT-COMMANDS** is executed. The return status is the exit status of the last command executed, or zero if no condition tested true.

Inside the **if** statement, you can use another **if** statement. You may use as many levels of nested **if**s as you can logically manage.

For example:

```
japin@localhost:~/bash-guide$ cat testleap.sh
#!/bin/bash
# This script will test if we're in a leap year or not.

year=`date +%Y`

if [ $[$year % 400] -eq "0" ]; then
    echo "This is a leap year. February has 29 days."
elif [ $[$year % 4] -eq "0" ]; then
    if [ $[$year % 100] -ne "0" ]; then
        echo "This is a leap year. February has 29 days."
    else
        echo "This is not a leap year. February has 28 days."
    fi
else
    echo "This is not a leap year. February has 28 days."
fi
```

The above script can be shortend using the *Boolean operators* "AND" (&&) and "OR" (||).


```
japin@localhost:~/bash-guide$ cat leaptest.sh
#!/bin/bash
# This script will test if we're in a leap year or not.

year=`date +%Y`
if (( ("$year" % 400) == "0" )) || (( ("$year" % 4 == "0") && ("$year" % 100 != "0") )); then
    echo "This is a leap year. Don't forget to charge the extra day!"
else
    echo "This is not a leap year."
fi
```

We use the double brackets for testing an arithmetic expression. This is equivalent to the **let** statement.
