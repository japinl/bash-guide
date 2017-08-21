# Regular expressions

A *regular expression* is a pattern that describes a set of strings. Any metacharacter with special meaning may be quoted by preceding it with a backslash.

## Regular expression metacharacters

 Operator   | Effect
:-----------|:--------
 .          | Matches any single character.
 ?          | The preceding item is optional and will be matched, at most, once.
 \*         | The preceding item will be matched zero or more times.
 \+         | The preceding item will be matched one or more times.
 {N}        | The preceding item is matched exactly N times.
 {N,}       | The preceding item is matched N or more times.
 {N,M}      | The preceding item is matched at least N times, but not more than M times.
 \-         | Represents the range if it's not first or last in a list or the ending point of a range in a list.
 \^         | Matches the empty string at the beginning of a line; also represents the characters not in the range of a list.
 \$         | Matches the empty string at the end of a line.
 \\b        | Matches the empty string at the edge of a word.
 \\B        | Matches the empty string provided it's not at the edge of a word.
 \\<        | Matches the empty string at the beginning of word.
 \\>        | matches the empty string at the end of word.

Two regular experssions may be joined by the infix operator "|"; the resulting regular experssion matches any string matching either subexpression.
