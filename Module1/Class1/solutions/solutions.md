# Solutions for Class 1 exercises

This file shows example commands and expected outputs for the exercises. Paths assume you copied course data into `~/module1/data/`.

Part A — navigation & files
1. `pwd` and `ls -lh ~/module1/data` — prints current directory and lists data files.
2. `mkdir -p ~/module1/exercise1 && cd ~/module1/exercise1` — creates and moves into folder.
3. `touch test.txt; cp test.txt test_backup.txt; mv test.txt final.txt; ls -l` — shows `final.txt` and `test_backup.txt` (before deletion).
4. `ls` then `rm test_backup.txt` — removes backup.
5. `chmod +x final.txt; ls -l final.txt` — `-rwx` will show execute permission.

Part B — inspecting
6. `head -4 ~/module1/data/genes.fasta` — prints first 4 lines (header + sequence).
7. `tail -3 ~/module1/data/ecoli_genome.fasta` — last 3 lines of genome file.
8. `wc -l ~/module1/data/ecoli_genome.fasta` — prints line count.
9. `grep ">" ~/module1/data/genes.fasta` — prints header lines.

Part C — searching & counting
10. `grep -c ">" ~/module1/data/genes.fasta` — number of sequences.
11. `grep -c ">" ~/module1/data/ecoli_genome.fasta` — usually 1 for the genome file.
12. `grep -i "recA" ~/module1/data/genes.fasta` — finds header with `recA`.
13. `grep -v "^#" ~/module1/data/annotations.gff3 | wc -l` — counts non-comment feature lines.
14. `cut -f3 ~/module1/data/annotations.gff3 | grep -v "^#" | sort | uniq -c` — tallies feature types.
15. `grep -v ">" ~/module1/data/genes.fasta | tr -d '\n' | tr -cd 'GCgc' | wc -c` — counts G/C bases across sequences.

Part D — pipes & redirection
16. `grep ">" ~/module1/data/genes.fasta > ~/module1/gene_headers.txt && echo "analysis complete" >> ~/module1/gene_headers.txt` — saves headers and appends line.
17. `grep -c ">" ~/module1/data/*.fasta` — counts sequences in every FASTA file.
18. `cut -f9 ~/module1/data/annotations.gff3 | grep -v "^#" | sed -n 's/.*Name=\([^;]*\).*/\1/p'` — prints Name= attribute for gene lines.

Part E — scripting
19. `./summarize.sh ~/module1/data` — prints per-file sequence counts and character counts. (Make executable with `chmod +x summarize.sh`.)
20. `./count_features.sh ~/module1/data/annotations.gff3` — prints counts for `gene`, `mRNA`, and `exon`.

Challenge hints
21. Use `grep ">"` with `awk`/`sed` to compute lengths and sort to find the longest name.
22. Compute GC percentage by counting G/C and dividing by total bases using `awk` for division.
