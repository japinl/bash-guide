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
