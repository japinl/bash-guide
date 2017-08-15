# Bash Guide Notes

## Overview of set debugging options

 Short notation | Long notation  | Result
:---------------|:---------------|:-----------
 set -f         | set -o noglob  | Disable file name generation using metacharacters (globbing).
 set -v         | set -o verbose | Prints shell inputs lines as they are read.
 set -x         | set -o xtrace  | Print command traces before executing command.

The dash is used to activate a shell option and a plus to deactivate it.
