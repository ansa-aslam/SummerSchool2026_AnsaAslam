# Python Cheat Sheet — Module 1
*For biological data handling. Print and keep.*

## Run a script
```bash
python3 myscript.py            # run a file
python3 -c "print(2+2)"        # run one line
```

## Variables & types
```python
name = "lacZ"        # str (text)
length = 1200        # int (whole number)
gc = 51.4            # float (decimal)
is_gene = True       # bool
```
| Operator | Example | Result |
|---|---|---|
| `+ - * /` | `10 / 4` | `2.5` |
| `//` `%` | `10 // 4`, `10 % 4` | `2`, `2` |
| `**` | `2 ** 3` | `8` |
| `==` `!=` `<` `>` | `gc > 50` | `True` |

## Strings (DNA lives here)
```python
seq = "ATGCGTAC"
len(seq)             # 8
seq[0]               # 'A'  (indexing starts at 0)
seq[0:3]             # 'ATG' (slicing)
seq.count("G")       # count a letter
seq.upper() / seq.lower()
seq.replace("T", "U")   # DNA -> RNA
"ATG" in seq         # True/False membership
```

## Lists & dictionaries
```python
genes = ["thrA", "lacZ", "recA"]
genes.append("rpoB")     # add
genes[0]                 # 'thrA'
len(genes)               # 4

counts = {"A": 0, "C": 0, "G": 0, "T": 0}   # dictionary
counts["G"] += 1         # update a value
counts["G"]              # read a value
```

## Control flow
```python
if gc > 50:
    print("GC-rich")
elif gc == 50:
    print("balanced")
else:
    print("AT-rich")

for base in seq:          # loop over each character
    print(base)

for gene in genes:        # loop over a list
    print(gene)
```

## Functions
```python
def gc_content(dna):
    """Return GC% of a DNA string."""
    gc = dna.count("G") + dna.count("C")
    return 100 * gc / len(dna)

print(gc_content("ATGCGC"))   # 66.67
```

## File handling
```python
with open("genes.fasta") as f:      # auto-closes the file
    for line in f:
        line = line.strip()         # remove trailing newline
        if line.startswith(">"):
            print("header:", line)

with open("out.txt", "w") as f:     # "w" write, "a" append
    f.write("hello\n")
```

## Biopython essentials
```python
from Bio import SeqIO

# FASTA
for rec in SeqIO.parse("genes.fasta", "fasta"):
    print(rec.id, len(rec.seq))
    print(rec.seq.reverse_complement())

# FASTQ (quality lives in letter_annotations)
for rec in SeqIO.parse("sample_reads.fastq", "fastq"):
    quals = rec.letter_annotations["phred_quality"]
    print(rec.id, sum(quals)/len(quals))   # mean quality
```

## Handy patterns
```python
# GC% the clean way
seq = seq.upper()
gc = (seq.count("G") + seq.count("C")) / len(seq) * 100

# count every base with a dictionary
counts = {}
for b in seq:
    counts[b] = counts.get(b, 0) + 1
```
> ⚠️ Top mistakes: indexing starts at **0** · indentation must be consistent (4 spaces) · `=` assigns, `==` compares · strings need quotes.
