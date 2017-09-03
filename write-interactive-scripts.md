# Writing interactive scripts

Some scripts run without any interaction from the user at all. Advantages of non-interactive scripts include:

* The script runs in a predictable way every time.
* The script can run in the background.

However, many scripts require input from user, or give output to the user as the script is running. The advantanges of interactive scripts are, among others:

* More flexible scripts can be built.
* Users can customize the script as it runs or make it behave in different ways.
* The script can report its progress as it runs.

Bash has the **echo** and **printf** commands to provide comments for users.

## Using the echo built-in command

The **echo** built-in command outputs its arguments, separated by spaces and terminated with a newline character. The return status is always zero. **echo** takes a couple of options:

* *-e*: interprets backslash-escaped characters.
* *-n*: suppresses the trailing newline.

```
japin@localhost:~/bash-guide$ cat penguin.sh
#!/bin/bash

# This script lets you present different menus to Tux. He will only be happy
# when given a fish. To make it more fun, we add a couple more animals.

if [ "$menu" == "fish" ]; then
    if [ "$animal" == "penguin" ]; then
        echo -e "Hmmmmmm fish... Tux happy!\n"
    elif [ "$animal" == "dolphin" ]; then
        echo -e "\a\a\aPweetpeettreetppeterdepweet!\a\a\a\n"
    else
        echo -e "*prrrrrrrrt*\n"
    fi
else
    if [ "$animal" == "penguin" ]; then
        echo -e "Tux don't like that. Tux wants fish!\n"
        exit 1
    elif [ "$animal" == "dolphin" ]; then
        echo -e "\a\a\aPweetpeettreetppeterdepweet!\a\a\a\n"
        exit 2
    else
        echo -e "Will you read this sign?! Don't feed the "$animal "s!\n"
        exit 3
    fi
fi
japin@localhost:~/bash-guide$ cat feed.sh
#!/bin/bash
# This script acts upon the exit status given by penguin.sh

if [ "$#" != "2" ]; then
    echo -e "Usage of the feed script:\t$0 food-on-menu animal-name\n"
    exit 1
else
    export menu="$1"
    export animal="$2"

    echo -e "Feeding $menu to $animal...\n"

    feed="./penguin.sh"

    $feed $menu $animal
    result="$?"

    echo -e "Done feeding.\n"

    case "$result" in
        1)
            echo -e "Guard: \"You'd better give'm a fish, less they get violent...\"\n"
            ;;
        2)
            echo -e "Guard: \"No wonder they flee our plant...\"\n"
            ;;
        3)
            echo -e "Guard: \"Buy the food that the Zoo provides at the entry, you ***\"\n"
            echo -e "Guard: \"You want to poison them, do you?\"\n"
            ;;
        *)
            echo -e "Guard: \"Don't forget the guide!\"\n"
            ;;
    esac
fi

echo "Leaving..."
echo -e "\a\a\aThanks for visiting the Zoo, hope to see you again soon!\n"
japin@localhost:~/bash-guide$ ./feed.sh apple camel
Feeding apple to camel...

Will you read this sign?! Don't feed the camel s!

Done feeding.

Guard: "Buy the food that the Zoo provides at the entry, you ***"

Guard: "You want to poison them, do you?"

Leaving...
Thanks for visiting the Zoo, hope to see you again soon!

japin@localhost:~/bash-guide: ./feed.sh apple
Usage of the feed script:	./feed.sh food-on-menu animal-name

```

Escape sequences used by the echo command

 Sequence | Meaning
:---------|:------------
 \\a      | Alert (bell).
 \\b      | Backspace.
 \\c      | Suppress trailing newline.
 \\e      | Escape.
 \\f      | Form feed.
 \\n      | Newline.
 \\r      | Carriage return.
 \\t      | Horizontal tab.
 \\v      | Vertical tab.
 \\\      | Backslash.
 \0NNN    | The eight-bit character whose value is the octal value NNN (zero to three octal digits).
 \NNN     | The eight-bit character whose value is the octal value NNN (one to three octal digits).
 \xHH     | The eight-bit character whose value is the hexadecimal value (one or two hexadecimal digits).


## Catching user input

The **read** built-in command is the counterpart of the **echo** and **printf** commands. The syntax of the **read** command is as follows:

```
read [options] NAME1 NAME2 ... NAMEN
```

One line is read from the standard input, or from the file descriptor supplied as an argument to *-u* option. The first word of the line is assigned to the first name, **NAME1**, the second word to the second name, and so on, with leftover words and their intervening separators assigned to the last name, **NAMEN**. If there are fewer words read from the input stream than there are names, the remaining names are assigned empty values.

If no names are supplied, the line read is assigned to the variable **REPLY**. The return code of the **read** command is zero, unless an end-of-file character is encountered, if **read** times out or if an invalid file descriptor is supplied as the argument to the *-u* option.

The following options are supported by the Bash **read** built-in:

 Option        | Meaning
:--------------|:---------------
 -a ANAME      | The words are assigned to sequential indexes of the array variable **ANAME**, starting at 0. All elements are removed from **ANAME** before the assignment. Other **NAME** arguments are ignored.
 -d DELIM      | The first character of **DELIM** is used to terminate the input line, rather than newline.
 -e            | **readline** is used to obtain the line.
 -n NCHARS     | **read** returns after reading **NCHARS** characters rather than waiting for a complete line of input.
 -p PROMPT     | Display **PROMPT**, without a trailing newline, before attempting to read any input. The prompt is displayed only if input is coming from a terminal.
 -r            | If this option is given, backslash does not act as an escape character. The backslash is considered to be part of the line. In particular, a backslash-newline pair may not be used as a line continuation.
 -s            | Silent mode. If input is coming from a termianl, characters are not echoed.
 -t TIMEOUT    | Cause **read** to time out and return failure if a complete line of input is not read within **TIMEOUT** seconds. This option has no effect if **read** is not reading input from the terminal or from a pipe.
 -u FD         | Read input from file descriptor **FD**.

## Redirection and file descriptors

As you know from basic shell usage, input and output of a command may be redirected before it is executed, using a special notation - the redirection operators - interpreted by the shell. Redirection may also be used to open and close files for the current shell execution environment.

File input and output are accomplished by integer handles that track all open files for a given process. These numeric values are known as file descriptors. The best known file descriptors are *stdin*, *stout* and *stderr*, with file descriptor numbers 0, 1 and 2, respectively.

The output below shows how the reserved file descriptors point to actual devices:

```
japin@localhost:~/bash-guide$ ls -l /dev/std*
lrwxrwxrwx 1 root root 15 Sep  3 10:21 /dev/stderr -> /proc/self/fd/2
lrwxrwxrwx 1 root root 15 Sep  3 10:21 /dev/stdin -> /proc/self/fd/0
lrwxrwxrwx 1 root root 15 Sep  3 10:21 /dev/stdout -> /proc/self/fd/1
japin@localhost:~/bash-guide$ ls -l /proc/self/fd/[0-2]
lrwx------ 1 japin japin 64 Sep  3 19:51 /proc/self/fd/0 -> /dev/pts/0
lrwx------ 1 japin japin 64 Sep  3 19:51 /proc/self/fd/1 -> /dev/pts/0
lrwx------ 1 japin japin 64 Sep  3 19:51 /proc/self/fd/2 -> /dev/pts/0
```
