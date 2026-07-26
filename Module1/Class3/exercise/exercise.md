# Class 3 — Exercises
**Python Programming Fundamentals**

Write your code into a script called `class2_answers.py` as you go, and run it with:

```bash
python3 class3_answers.py
```

---

## Part A — Control flow
5. Write an `if/elif/else` that prints `"GC-rich"` if a variable `gc` is above 60, `"AT-rich"` if below 40, otherwise `"Average GC"`. Test it with `gc = 52.47`.
6. Using a `for` loop over the string `"ATGCGGTA"`, print each base on its own line **in lower case**.
7. Using a `while` loop, print a countdown from 5 down to 1.

## Part B — Strings, lists, dictionaries (the core)
8. Write a function `gc_content(seq)` that returns the GC percentage of any sequence. Test it on `"GGGGCCCCAAAATTTT"` (should be `50.0`).
9. Write a function `reverse_complement(seq)` and test it: `reverse_complement("AAAACGT")` should give `"ACGTTTT"`.
10. Write a function `base_counts(seq)` that returns a dictionary of how many times each base appears. Test it on `"AATTGGCC"` (should give `{'A':2,'T':2,'G':2,'C':2}`).
11. Make a **list** of the gene names `["thrA", "lacZ", "recA", "rpoB"]`. Append `"gyrA"`, then print how many genes are in the list and the last one.

## Part C — File handling & parsing (real data)
12. Without Biopython, open `../../data/genes.fasta` and count how many header lines (sequences) it contains. (Expect **8**.)
13. Reuse `read_fasta` (from `parse_fasta.py`, or `from parse_fasta import read_fasta`) to load `genes.fasta` into a dictionary. Print the **name and length** of the **longest** gene.
14. Using your `gc_content` function on the parsed `genes.fasta`, print every gene whose GC% is **above 52%**. (Expect `thrA` and `recA`.)

## Part D — Biopython
15. Use `SeqIO.parse` to loop over `../../data/genes.fasta` and print each `record.id` with its length and GC% (use `gc_fraction` from `Bio.SeqUtils`, ×100).
16. Use `SeqIO.parse` on `../../data/sample_reads.fastq` to count the **total number of reads**. (Expect **2000**.)
17. **Read-quality filter (a real QC step):** loop over `sample_reads.fastq`, compute each read's **mean Phred quality** from `record.letter_annotations["phred_quality"]`, and count how many reads have mean quality **≥ 30**. Print both the count that passed and the count that failed.

## 🚀 Challenge (optional)
18. Write a function `transcribe(seq)` (DNA→RNA) **and** a function `translate_first_codon(seq)` that returns the RNA codon of the first three bases. Test on `"ATGCGT"`.
19. Find and print the gene in `genes.fasta` with the **highest GC%** using Biopython (`max(..., key=...)`). (Expect `recA`.)
20. Write the IDs of all reads that **passed** the quality filter (mean Phred ≥ 30) from Q17 into a new file `passed_reads.txt`, one ID per line. Then count the lines to confirm it matches your Q17 number.

---
### Submit
Save `class3_answers.py`
