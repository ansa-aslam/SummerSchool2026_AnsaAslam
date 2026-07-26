# Linux & Bash Cheat Sheet — Module 1
*Print this. Keep it next to your keyboard.*

## Navigation
| Command | Does |
|---|---|
| `pwd` | where am I? |
| `ls` / `ls -lh` / `ls -la` | list / long+sizes / show hidden |
| `cd folder` / `cd ..` / `cd ~` / `cd -` | enter / up / home / back |
| `tree` | show folder tree (if installed) |

## Files & folders
| Command | Does |
|---|---|
| `mkdir -p a/b` | make folders (and parents) |
| `touch f` | create empty file |
| `cp a b` / `cp -r dir1 dir2` | copy file / folder |
| `mv a b` | move **or** rename |
| `rm f` / `rm -r dir` | delete file / folder ⚠️ **no undo** |

## Permissions
| Command | Does |
|---|---|
| `ls -l` | show `rwx` for owner/group/others |
| `chmod +x script.sh` | make executable |

## Look inside files
| Command | Does |
|---|---|
| `cat f` | print whole file |
| `head -n 5 f` / `tail -n 5 f` | first / last 5 lines |
| `less f` | scrollable view (`q` to quit) |
| `wc -l f` / `wc -c f` | count lines / characters |

## Search & columns
| Command | Does |
|---|---|
| `grep "pat" f` | lines matching pattern |
| `grep -c ">" f.fasta` | **count sequences in a FASTA** |
| `grep -i` / `-v` / `-o` | ignore case / invert / only-match |
| `cut -f3 f` | column 3 (tab-separated) |
| `sort` / `uniq -c` | sort / count unique (tally idiom: `sort | uniq -c`) |
| `sed 's/old/new/'` | find & replace in a stream |
| `awk '$3=="gene"{print $5-$4+1}'` | column math/filtering |

## Combining commands
| Symbol | Does |
|---|---|
| `\|` | pipe: output of left → input of right |
| `>` | save to file (**overwrites**) |
| `>>` | append to file |
| `*` | wildcard (e.g. `*.fasta`) |
| `$(cmd)` | run cmd, use its output |

## Bash script skeleton
```bash
#!/usr/bin/env bash
# describe what it does
input="$1"                 # first argument
if [ -z "$input" ]; then echo "Usage: ./x.sh <arg>"; exit 1; fi
for f in "$input"/*.fasta; do
    n=$(grep -c ">" "$f")
    echo "$f : $n sequences"
done
```
Run with: `chmod +x x.sh` then `./x.sh data`.

## Bio one-liners worth memorizing
```bash
grep -c ">" file.fasta                          # number of sequences
grep -v ">" g.fasta | grep -o "[GC]" | wc -l    # count G/C bases
cut -f3 ann.gff3 | grep -v "^#" | sort | uniq -c # tally feature types
wc -l reads.fastq | awk '{print $1/4}'          # number of FASTQ reads
```
> ⚠️ Top mistakes: forgetting `./` before a script · using `>` when you meant `>>` · `rm` without checking with `ls` first.
