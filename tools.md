# GUN sed

A **S**tream **ED**itor is used to perform basic transformations on text read from a file or a pipe. The result is sent to standard output. The syntax for the **sed** command has no output file specification, but results can be saved to a file using output redirection. The editor does not modify the original input.

The **sed** program can perform text pattern substitutions and deletions using regular expressions, like the ones used with the **grep** command. The editing commands are similar to the ones used in the **vi** editor:

 Command | Result
:--------|:----------
 a\      | Append text below current line.
 c\      | Change text in the current line with new text.
 d       | Delete text.
 i\      | Insert text above current line.
 p       | Print text.
 r       | Read a file.
 s       | Search and replace text.
 w       | Write to a file.

You can also give options to **sed**. An overview is in the table below:

 Option    | Effect
:----------|:-------------
 -e SCRIPT | Add the commands in SCRIPT to the set of commands to be run while processing the input.
 -f        | Add the commands contained in the file SCRIPT-FILE to the set of commands to be run while processing the input.
 -n        | Silent mode.
 -V        | Print version information and exit.

The **sed** info pages contain more information.

## Interactive editing

### Basic

1. Printing lines containing a pattern
   ```
   $ sed -n '/text/p' example
   ```
2. Deleting lines of input containing a pattern
   ```
   $ sed '/text/d' example
   ```
3. Using regular expression in sed
   ```
   $ sed '/^This.*errors.$/p' example
   ```

### Ranges of lines

```
$ sed '2,4d' example
```

In the above example, we delete lines 2 to 4 using range address, together with the **d** command. We can also print the file from starting to a certain line:

```
$ sed '3,$d' example
```

This only prints the first two lines of the example.

The following command prints the first line containing the pattern "a text", up to and including the next line containing the pattern "This":

```
$ sed -n '/a text/,/This/p' example
```

### Find and replace

```
$ sed 's/erors/errors/' example
```

The above command will find the first matched string and replece it, but the following matched will not be replaced. We can use the following command to replace all matched string.

```
$ sed 's/erors/errors/g' example
```

To insert a string at the begining of each line of a file, for instance for quoting:

```
$ sed 's/^/> /' example
```

Also, insert some string at the end of each line:

```
$ sed 's/$/EOL/' example
```

Multiple find and replace commands are separated with individual *-e* options:

```
$ sed -e 's/erors/errors/g' -e 's/last/final/g' example
```

## Non-interactive editing

Multiple **sed** commands can be put in a file and executed using the *-f* option. When creating such a file, make sure that:

* No trailing white spaces exist at the end of lines.
* No quotes are used.
* When entring text to add or replace, all except the last line end in a backslash.

# GUN awk

Best documentation *GAWK: Effective AWK Programming: A User's Guide for GNU Awk*.

The basic function of **awk** is to search files for lines or other text units containing one or more patterns. When a line matches one of the patterns, special actions are performed on that line.

There are several ways to run **awk**. If the program is short, it is easiest to run it on the command line:

```
awk PROGRAM inputfile(s)
```

If multiple changes have to be made, possibly regularly and on multiple files, it is easier to put the awk commands in a script. This is read like this:

```
awk -f PROGRAM-FILE inputfile(s)
```

### The print program

The **print** command in **awk** outputs selected data from the input file.

When **awk** reads a line of a file, it divides the line in fields based on the specified *input field separator*, FS, which is an **awk** variable. This variable is predefined to be one or more spaces or tabs.

The variables *$1, $2, $3, ..., $N* hold the values of the first, second, third until the last field of an input line. The *$0* holds the value of the entire line.

A regular expression can be used as a pattern by enclosing it in slashes. The regular expression is then tested against the entire text of each record. The syntax is as follows:

```
awk 'EXPRESSION { PROGRAM }' file(s)
```

we can search the */etc* directory for files ending in ".conf" and starting with either "a" or "x", using extended regular expressions:

```
ls -l /etc | awk '/\<(a|x).*\.conf$/ { print $9 }'
```

In order to precede output with comments, use the **BEGIN** statement:

```
ls -l /etc | awk 'BEGIN { print "Files found:\n" } /\<(a|x).*\.conf$/ { print $9 }'
```

The **END** statement can be added for inserting text after the entire input is processed:

```
ls -l /etc | awk 'BEGIN { print "Files found:\n" } /\<(a|x).*\.conf$/ { print $9 } END { print "Can I do anything else for you?" }'
```

As commands tend to get a little longer, you might want to put them in a script, so they are reusable. An **awk** script contains **awk** statements defining patterns and actions.
