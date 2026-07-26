#!/usr/bin/env python3
"""
concepts_demo.py — a runnable reference of EVERY Python concept from Class 2.

This is your cheat-sheet you can actually run. Each numbered section is one
concept. Read it top to bottom, run it, then come back whenever you forget
"how do I write a loop again?".

    python3 concepts_demo.py
"""

print("=" * 60)
print(" 1. VARIABLES — labelled boxes that hold a value")
print("=" * 60)
gene_name = "lacZ"          # text  (str)
gene_length = 600           # whole number (int)
gc_percent = 53.7           # decimal number (float)
is_coding = True            # yes/no (bool)
print(gene_name, gene_length, gc_percent, is_coding)


print("\n" + "=" * 60)
print(" 2. DATA TYPES — type() tells you what kind of value something is")
print("=" * 60)
print(type(gene_name))      # <class 'str'>
print(type(gene_length))    # <class 'int'>
print(type(gc_percent))     # <class 'float'>
print(type(is_coding))      # <class 'bool'>


print("\n" + "=" * 60)
print(" 3. OPERATORS — math and comparisons")
print("=" * 60)
print("2 + 3   =", 2 + 3)
print("10 / 4  =", 10 / 4)      # true division -> 2.5
print("10 // 4 =", 10 // 4)     # floor division -> 2
print("10 % 4  =", 10 % 4)      # remainder (modulo) -> 2
print("2 ** 8  =", 2 ** 8)      # power -> 256
print("600 > 500 :", 600 > 500) # comparison -> True
print("'A' == 'A':", "A" == "A")


print("\n" + "=" * 60)
print(" 4. STRINGS — text, and the things you can do to DNA strings")
print("=" * 60)
dna = "atgcGGTACC"
print("original     :", dna)
print("upper()      :", dna.upper())
print("count('G')   :", dna.upper().count("G"))
print("length       :", len(dna))
print("slice [0:3]  :", dna[0:3])       # first 3 characters
print("reversed     :", dna[::-1])      # reverse with a slice
print("replace T->U :", dna.upper().replace("T", "U"))


print("\n" + "=" * 60)
print(" 5. IF / ELIF / ELSE — make decisions")
print("=" * 60)
gc = 53.7
if gc > 60:
    print("GC-rich sequence")
elif gc > 40:
    print("Average GC sequence")
else:
    print("AT-rich sequence")


print("\n" + "=" * 60)
print(" 6. FOR LOOP — do something for each item")
print("=" * 60)
for base in "ATGC":
    print("  base:", base)


print("\n" + "=" * 60)
print(" 7. WHILE LOOP — repeat while a condition is true")
print("=" * 60)
countdown = 3
while countdown > 0:
    print("  countdown:", countdown)
    countdown = countdown - 1


print("\n" + "=" * 60)
print(" 8. LISTS — an ordered collection you can grow")
print("=" * 60)
genes = ["thrA", "lacZ", "recA"]
print("list        :", genes)
print("first item  :", genes[0])
print("last item   :", genes[-1])
genes.append("rpoB")            # add to the end
print("after append:", genes)
print("how many    :", len(genes))


print("\n" + "=" * 60)
print(" 9. DICTIONARIES — look things up by name (key -> value)")
print("=" * 60)
# Count each nucleotide in a sequence using a dictionary.
seq = "AAGGCTAGCTAGCATG"
counts = {}                     # empty dictionary
for base in seq:
    if base in counts:
        counts[base] = counts[base] + 1
    else:
        counts[base] = 1
print("sequence    :", seq)
print("base counts :", counts)
print("number of A :", counts["A"])


print("\n" + "=" * 60)
print(" 10. FUNCTIONS — package a recipe to reuse it")
print("=" * 60)
def gc_content(s):
    """Return GC percentage of a sequence."""
    s = s.upper()
    return (s.count("G") + s.count("C")) / len(s) * 100

print("gc_content('GGCCAATT') =", gc_content("GGCCAATT"), "%")
print("gc_content('AAAATTTT') =", gc_content("AAAATTTT"), "%")


print("\n" + "=" * 60)
print(" 11. FILE HANDLING — read a real file from disk")
print("=" * 60)
path = "../../data/genes.fasta"
header_count = 0
with open(path) as handle:          # 'with' auto-closes the file
    for line in handle:
        if line.startswith(">"):
            header_count += 1
print(f"{path} contains {header_count} sequences")
