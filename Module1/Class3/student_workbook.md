# Class 3 — Python Programming Fundamentals
## Student Workbook
**Theme: From the Command Line to Your First Real Biological Computation**

> 📖 **How to use this workbook.** Read along and **type every `⌨️` block yourself**

---

## Today you will learn to
- Use the core data **types** and **operators**.
- Make decisions with `if`, and repeat work with `for` and `while` loops.
- Use **strings**, **lists**, and **dictionaries**.
- Write reusable **functions** — including a clean `gc_content` (remember yesterday's messy Bash version?).
- **Open and read files** in Python, and parse a FASTA file by hand.

---

## 1. Making decisions: `if / elif / else`

💡 In Python, **indentation is the syntax** — the indented block belongs to the `if`. Use 4 spaces, and don't forget the colon `:`.

⌨️
```python
gc = 53.7
if gc > 60:
    print("GC-rich")
elif gc > 40:
    print("Average GC")
else:
    print("AT-rich")
```
> ⚠️ Two errors you *will* meet today: forgetting the `:` (`SyntaxError`) and uneven indentation (`IndentationError`). They are normal — read the message, fix the line.

---


## 2. Strings = your DNA toolkit

A DNA sequence is just a **string** you can measure and transform.

⌨️
```python
dna = "atgcGGTACC"
len(dna)               # 10
dna.upper()            # "ATGCGGTACC"
dna.upper().count("G") # count a base
dna[0:3]               # "atg"  — a slice: positions 0,1,2 (3 excluded)
dna[-1]                # "C"    — last character
dna[::-1]              # reverse the string
dna.upper().replace("T", "U")   # transcription: DNA -> RNA
```

> 💡 **Slicing:** `seq[start:stop]` includes `start` but **excludes** `stop`. Counting starts at **0**.
> ⚠️ Off-by-one is the classic beginner trap: `dna[0:3]` gives **3** characters, not 4.

---

## 3. Repeating work: `for` and `while`

⌨️ A `for` loop walks through each item:
```python
for base in "ATGC":
    print("base:", base)
```

⌨️ A `while` loop repeats while a condition is true:
```python
countdown = 3
while countdown > 0:
    print(countdown)
    countdown = countdown - 1     # MUST change, or it loops forever
```
> ⚠️ If your terminal hangs in an infinite loop, press **`Ctrl-C`** to stop it.

---

## 4. Lists — many values in order

⌨️
```python
genes = ["thrA", "lacZ", "recA"]
genes[0]              # "thrA"  (first; counting starts at 0)
genes[-1]             # "recA"  (last)
len(genes)            # 3
genes.append("rpoB")  # add to the end
genes                 # ["thrA", "lacZ", "recA", "rpoB"]
```

---

## 5. Dictionaries — look up by name (great for counting)

💡 A **dictionary** maps a **key** to a **value**: `{key: value}`. Perfect for tallying nucleotides — the Python version of yesterday's `sort | uniq -c`.

⌨️ Count every base in a sequence:
```python
seq = "AAGGCTAGCTAGCATG"
counts = {}                  # start empty
for base in seq:
    if base in counts:
        counts[base] = counts[base] + 1
    else:
        counts[base] = 1
print(counts)                # {'A': 5, 'G': 5, 'C': 3, 'T': 3}
print(counts["A"])           # 5
```
🧬 A dictionary also encodes base-pairing rules: `{"A":"T", "T":"A", "G":"C", "C":"G"}`.

---

## 6. Functions — write once, reuse forever

💡 `def` names a recipe; the indented body is the steps; `return` hands back the answer.

⌨️ The clean GC% we kept promising:
```python
def gc_content(seq):
    """Return GC percentage of a sequence (0-100)."""
    seq = seq.upper()
    return (seq.count("G") + seq.count("C")) / len(seq) * 100

gc_content("GGCCAATT")   # 50.0
gc_content("AAAATTTT")   # 0.0
```

⌨️ Two more biological functions (all in `dna_basics.py`):
```python
def reverse_complement(seq):
    seq = seq.upper()
    pairs = {"A":"T", "T":"A", "G":"C", "C":"G"}
    complement = ""
    for base in seq:
        complement = complement + pairs[base]
    return complement[::-1]            # reverse it

def transcribe(seq):
    return seq.upper().replace("T", "U")   # DNA -> RNA

reverse_complement("ATGC")   # "GCAT"
transcribe("ATGC")           # "AUGC"
```

⌨️ Run the whole script:
```bash
python3 dna_basics.py
```
✅ You should see GC content **56.0 %** for the demo sequence, plus its reverse complement and RNA. **That clunky Bash GC% is now three clean lines!**

---

## 7. Reading files in Python

💡 `with open(path) as handle:` opens a file and **closes it automatically**. Loop over it line by line.

⌨️
```python
path = "../../data/genes.fasta"
header_count = 0
with open(path) as handle:
    for line in handle:
        if line.startswith(">"):   # FASTA headers start with '>'
            header_count += 1
print(header_count)                # 8
```
> ⚠️ Each line keeps an invisible newline `\n`. Use `line.strip()` before measuring or storing sequence, or your lengths will be wrong.

---

## 8. Parse a FASTA file by hand → dictionary

🧬 A real parser: headers start a new record; sequence lines are glued together; store as `{id: sequence}`. This is `read_fasta` inside `parse_fasta.py`:

```python
def read_fasta(path):
    sequences = {}
    current_id = None
    with open(path) as handle:
        for line in handle:
            line = line.strip()
            if line == "":
                continue
            if line.startswith(">"):
                current_id = line[1:].split()[0]   # drop '>', keep first word
                sequences[current_id] = ""
            else:
                sequences[current_id] += line       # glue sequence lines
    return sequences
```

⌨️ Run it:
```bash
python3 parse_fasta.py
python3 parse_fasta.py ../../data/ecoli_genome.fasta
```
✅ For `genes.fasta`: **8 sequences, 9000 total bp, average 1125 bp**.
✅ For `ecoli_genome.fasta`: `chr1` 50000 bp, **GC = 51.41 %** — the *same* number as yesterday's Bash hack, but readable!

---

## ✅ End-of-class self-check
Tick these before you leave:
- [ ] I can run a Python script with `python3 file.py`.
- [ ] I know `str`, `int`, `float`, `bool` and can use `type()`.
- [ ] I can write an `if/elif/else` and a `for` loop (with correct indentation).
- [ ] I can build a dictionary that counts nucleotides.
- [ ] I wrote and called a `gc_content` function.
- [ ] I read a file with `with open(...)` and parsed FASTA into a dictionary.

## One-line summary to remember
**values → variables → control flow → functions → file_manipulation.** That's your first biological computation.

➡️ Now do `exercises/exercises.md`.

## Useful Links

- 🌐 [Google Collab](https://colab.research.google.com)
- 🌐 [W3school](https://www.w3schools.com/python/default.asp)
- 🌐 [GeeksforGeeks](https://www.geeksforgeeks.org/python/python-programming-language-tutorial/)
