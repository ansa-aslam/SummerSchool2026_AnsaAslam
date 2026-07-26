# Class 1 — Introduction to Linux & the Command Line
## Student Workbook
**Theme: From the Command Line to Your First Biological Script**

> 📖 **How to use this workbook.** Read along and **type every `⌨️` block yourself** — don't just watch. Typing is how your fingers and brain learn. Keep this file; you'll reuse the commands all course. Symbols: 💡 idea · 🧬 biology · ⌨️ type this · ⚠️ watch out · ✅ check yourself · 🚀 optional extra.

---

## Today you will learn to
- Move around a Linux computer using the keyboard instead of a mouse.
- Create, copy, move, and delete files and folders.
- Look inside biological files and search them.
- Combine commands into mini-pipelines.
- Write your **first script** that processes genome files automatically.

---

## 1. What is this black window?

- **Linux** is an operating system, like Windows or macOS. Almost every bioinformatics server and supercomputer runs Linux.
- The **terminal** is the window you type in. The **shell** (called **Bash**) is the program that reads your commands and runs them.
- **Why bother?** Biological data files are often too big for Excel. The command line lets you inspect and process files of *any* size in seconds — and **automate** the work so it's reproducible.

> 🧬 **Real-world:** when a journal reviewer asks "how did you get this number?", a saved command or script is your exact, repeatable answer.

⌨️ **Try it — is your terminal alive?**
```bash
echo "Hello, bioinformatics"
whoami
date
```
✅ You should see your greeting, your username, and today's date.

---

## 2. Where am I? Moving around

The file system is a tree that starts at `/` (the "root"). You are always standing *inside* one folder.

| Command | Meaning |
|---|---|
| `pwd` | **p**rint **w**orking **d**irectory — "where am I?" |
| `ls` | **l**i**s**t what's in this folder |
| `ls -l` | long list (permissions, size, date) |
| `ls -lh` | long list with human-readable sizes |
| `ls -la` | also show hidden files (names starting with `.`) |
| `cd foldername` | **c**hange **d**irectory — go *into* a folder |
| `cd ..` | go **up** one level |
| `cd ~` | go to your **home** folder |
| `cd -` | go back to where you just were |

⌨️ **Try it:**
```bash
pwd
ls
ls -lh
cd ~
cd ..
cd -
```

💡 **Paths are addresses.** Absolute paths start at `/` (e.g. `/home/you/data`). Relative paths start from where you are now (e.g. `data/genes.fasta`). `.` means "here", `..` means "one folder up".

---

## 3. Build your course workspace

⌨️
```bash
cd ~
mkdir -p module1/data        # make folder (and parents); no error if it exists
cd module1
pwd                          # should end in /module1
```
Now copy the course data files into `~/module1/data/` (your instructor will give you the source path):
```bash
cp /path/to/data/*.fasta  ~/module1/data/
cp /path/to/data/*.gff3   ~/module1/data/
ls -lh ~/module1/data
```
✅ You should see `ecoli_genome.fasta`, `genes.fasta`, and `annotations.gff3`.

---

## 4. Making and removing files & folders

| Command | What it does |
|---|---|
| `touch file.txt` | create an empty file |
| `mkdir results` | make a folder |
| `cp a b` | copy file `a` to `b` |
| `mv a b` | move **or** rename `a` to `b` |
| `rm file` | **delete a file (no undo!)** |
| `rm -r folder` | delete a folder and everything in it (careful!) |

⌨️
```bash
cd ~/module1
touch notes.txt
mkdir results
cp notes.txt notes_backup.txt
mv notes_backup.txt results/
mv notes.txt lab_notebook.txt
ls -R
```

> ⚠️ **There is no recycle bin.** `rm` deletes permanently. **Always run `ls` first** and read what you're about to delete.

---

## 5. Permissions (who can read/write/run a file)

`ls -l` shows something like `-rw-r--r--`. Read it in groups: **owner / group / others**, each with `r`ead `w`rite e`x`ecute.

The one that matters most today: **`x` = executable**. A script must be executable to run.

⌨️
```bash
ls -l lab_notebook.txt
chmod +x lab_notebook.txt    # add execute permission
ls -l lab_notebook.txt       # an 'x' now appears
```

---

## 6. Looking inside biological files

🧬 A **FASTA** file is plain text: a header line starting with `>`, then sequence lines.

| Command | What it does |
|---|---|
| `cat file` | print the whole file |
| `head file` | first 10 lines |
| `head -2 file` | first 2 lines |
| `tail -5 file` | last 5 lines |
| `wc -l file` | count lines |

⌨️
```bash
cd ~/module1/data
head genes.fasta
head -2 genes.fasta
tail -5 ecoli_genome.fasta
wc -l ecoli_genome.fasta
```
> ⚠️ Never `cat` a real multi-gigabyte genome — it floods the screen. Use `head`/`tail`. (Today's files are tiny, so `cat` is safe.)

---

## 7. Searching with `grep` (your most-used tool)

| Command | What it finds |
|---|---|
| `grep ">" genes.fasta` | every header line |
| `grep -c ">" genes.fasta` | **count** of headers = number of sequences |
| `grep -i "lacz" genes.fasta` | case-insensitive match |
| `grep -v ">" genes.fasta` | lines *without* `>` (just sequence) |

⌨️
```bash
grep ">" genes.fasta
grep -c ">" genes.fasta          # how many sequences?
grep -i "lacz" genes.fasta
grep -v ">" genes.fasta | head
```
💡 **Remember this one forever:** `grep -c ">" file.fasta` = *how many sequences are in this FASTA file*.

---

## 8. Pipes, redirection, wildcards

- **Pipe `|`** — send one command's output into the next.
- **Redirect `>`** — save output to a file (overwrites). **`>>`** appends.
- **Wildcard `*`** — match many files.

⌨️
```bash
# pipe: headers -> count
grep ">" genes.fasta | wc -l

# tally feature types in the annotation file
cut -f3 annotations.gff3 | grep -v "^#" | sort | uniq -c

# save and append
grep ">" genes.fasta > headers.txt
echo "run by $(whoami)" >> headers.txt
cat headers.txt

# wildcard: act on every fasta file
grep -c ">" *.fasta
```
> ⚠️ `>` **overwrites** — it erases the file first. Use `>>` when you want to *add* to a file.

---

## 9. Your first Bash script 🎉

A script is a text file full of commands you can run with one word.

⌨️ Create `~/module1/summarize.sh` (open with `nano summarize.sh` or VS Code) and type:
```bash
#!/usr/bin/env bash
# summarize.sh — count sequences in every FASTA file in a folder
# Usage: ./summarize.sh <folder>

folder="$1"                       # $1 = first word typed after the script name
echo "Summarizing FASTA files in: $folder"
echo "-----------------------------------"

for file in "$folder"/*.fasta     # repeat for each .fasta file
do
    count=$(grep -c ">" "$file")  # $( ) runs a command and captures its output
    echo "$file has $count sequences"
done

echo "-----------------------------------"
echo "Done."
```
Then make it executable and run it:
```bash
cd ~/module1
chmod +x summarize.sh
./summarize.sh data
```
✅ You should see a line per FASTA file showing its sequence count. **You just automated an analysis!**

Three new ideas you used:
- **`$1`** — an *argument* you pass to the script.
- **`for ... do ... done`** — a *loop* that repeats for each file.
- **`$(...)`** — *command substitution*: run a command and use its result.

---

## ✅ End-of-class self-check
Tick these before you leave:
- [ ] I can find out where I am (`pwd`) and what's here (`ls`).
- [ ] I made a `~/module1` workspace with a `data/` and `results/` folder.
- [ ] I can count sequences in a FASTA file with `grep -c ">" file.fasta`.
- [ ] I built a pipeline with `|` and saved output with `>`.
- [ ] I wrote, `chmod +x`'d, and ran `summarize.sh`.

## 🚀 Go further (optional, if you finish early)
- Make `summarize.sh` also print each file's line count (`wc -l`).
- Try `man grep` to read grep's manual (press `q` to quit).
- Look up `less file` — like `cat` but scrollable (arrow keys, `q` to quit).

## One-line summary to remember
**files → commands → pipes → scripts → automation.** That's bioinformatics on the command line.

➡️ Now do `exercises/exercises.md`.
