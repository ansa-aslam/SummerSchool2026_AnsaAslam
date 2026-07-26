# Class 1 — Exercises
**Linux & the Command Line**

Work in your `~/module1` folder. Use the files in `~/module1/data/`. Write each answer (the command you used) into a file called `class1_answers.txt` as you go:
```bash
nano ~/module1/class1_answers.txt
```
---

## Part A — Navigation & files (warm-up)
1. Print your current location, then list the contents of `~/module1/data` with human-readable sizes.
2. Make a new folder `~/module1/exercise1` and move into it.
3. Create an empty file called `test.txt`, copy it to `test_backup.txt`, then rename `test.txt` to `final.txt`. List the folder to confirm.
4. Delete `test_backup.txt`. (Run `ls` first!)
5. Make `final.txt` executable, then show its permissions to prove the `x` appeared.

## Part B — Inspecting biological files
6. Show the first 4 lines of `genes.fasta`.
7. Show the last 3 lines of `ecoli_genome.fasta`.
8. How many lines are in `ecoli_genome.fasta`?
9. Print only the header lines of `genes.fasta`.

## Part C — Searching & counting (the important part)
10. How many sequences are in `genes.fasta`? (One command.)
11. How many sequences are in `ecoli_genome.fasta`?
12. Find the header line that contains `recA` (case-insensitive).
13. Using a pipe, count how many feature lines (non-comment lines) are in `annotations.gff3`.
14. Tally how many `gene`, `mRNA`, and `exon` features are in `annotations.gff3`.
15. Count the number of `G` or `C` bases in `genes.fasta` (sequence lines only).

## Part D — Pipes, redirection, wildcards
16. Save all header lines from `genes.fasta` into a file `~/module1/gene_headers.txt`, then append the line `analysis complete` to it.
17. In one command, count the sequences in **every** `.fasta` file in `data/`.
18. Use `cut` to print only the gene **names** from `annotations.gff3` gene lines. (Hint: column 9, then look at the `Name=` part — `cut` + `sed` or `grep -o`.)

## Part E — Scripting
19. Modify `summarize.sh` so it also prints, for each file, the number of **sequence characters** (non-header characters). Hint: `grep -v ">" "$file" | wc -c`.
20. Write a brand-new script `count_features.sh` that takes a GFF3 file as argument `$1` and prints the feature-type tally (`gene`/`mRNA`/`exon` counts). Run it on `annotations.gff3`.

## 🚀 Challenge (optional)
21. Write a one-liner that prints the **longest** gene name in `genes.fasta` headers. (Hint: `grep ">"` → `awk '{print $1}'` → process.)
22. Compute the **GC percentage** of `ecoli_genome.fasta` using only command-line tools and `awk` for the division. (We'll do this more cleanly in Python tomorrow — see if you can hack it today.)

---
### Submit
Save `class1_answers.txt`, `gene_headers.txt`, and `count_features.sh` in `~/module1/`. These feed directly into the **Week 1 independent assignment**.
