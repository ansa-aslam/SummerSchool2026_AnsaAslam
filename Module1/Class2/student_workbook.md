# Class 2 — Python Programming Fundamentals
## Student Workbook
**Theme: From the Command Line to Your First Real Biological Computation**

> 📖 **How to use this workbook.** Read along and **type every `⌨️` block yourself** — don't just watch. Typing is how your fingers and brain learn.

---

## Today you will learn to
- Run Python and store data in **variables**.
- Use the core data **types** and **operators**.

---

## 1. Why Python?

Yesterday, to get the **GC percentage** of a genome, we wrote this in Bash:
```bash
total=$(grep -v ">" ecoli_genome.fasta | tr -d '\n' | wc -c)
gc=$(grep -v ">" ecoli_genome.fasta | grep -o "[GC]" | wc -l)
awk -v g=$gc -v t=$total 'BEGIN{printf "GC%% = %.2f\n", (g/t)*100}'
```
Three commands and an `awk` just to do **division**. It worked — but it was a hack.

In Python the same idea is a short, readable function:
```python
def gc_content(seq):
    seq = seq.upper()
    return (seq.count("G") + seq.count("C")) / len(seq) * 100
```

💡 **Bash moves and counts files. Python computes.** Today you cross that line.

⌨️ **Is your Python alive?** Open a terminal in the `code/` folder:
```bash
cd Class_2_Python_Fundamentals/code
python3 --version
python3 -c "print('Hello, Python')"
python3 -c "import Bio; print('Biopython', Bio.__version__)"
```
✅ You should see `Hello, Python` and a Biopython version number.

> 💡 **Two ways to run Python:** type `python3` for an interactive `>>>` prompt (great for trying one line), or `python3 file.py` to run a whole script (like `.sh` scripts).

---

## 2. Variables and data types

A **variable** is a labelled box that holds a value. Unlike Bash, no `$` needed.

⌨️
```python
gene_name = "lacZ"      # str   — text
gene_length = 600       # int   — whole number
gc_percent = 53.7       # float — decimal
is_coding = True        # bool  — True / False
print(gene_name, gene_length, gc_percent, is_coding)
type(gc_percent)        # <class 'float'>
```

| Type | Means | Biology example |
|---|---|---|
| `str` | text | a DNA sequence `"ATGC"` |
| `int` | whole number | a read count, a length |
| `float` | decimal | GC %, a quality score |
| `bool` | True/False | "did this read pass QC?" |

> ⚠️ `=` **stores** a value (`x = 5`). `==` **asks if two things are equal** (`x == 5`). Don't mix them up.

---

## 3. Operators

⌨️
```python
2 + 3        # 5
10 / 4       # 2.5   normal division
10 // 4      # 2     floor division (drops decimals)
10 % 4       # 2     remainder (modulo)
2 ** 8       # 256   power
600 > 500    # True
"A" == "A"   # True
```
## 4. Functions — write once, reuse forever

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

## 🚀 Go further (optional, if you finish early)
- Add an `N` (unknown base) to a sequence and make `reverse_complement` handle it.
- Print only the genes in `genes.fasta` whose GC% is above 52%.

➡️ Now do `exercises/exercises.md`.

## Useful Links

- 🌐 [Google Collab](https://colab.research.google.com)
- 🌐 [W3school](https://www.w3schools.com/python/default.asp)
- 🌐 [GeeksforGeeks](https://www.geeksforgeeks.org/python/python-programming-language-tutorial/)
