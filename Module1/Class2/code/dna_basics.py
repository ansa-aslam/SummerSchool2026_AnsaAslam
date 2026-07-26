#!/usr/bin/env python3
"""
dna_basics.py — your first biological computation in Python.

Run it with:
    python3 dna_basics.py

This file shows, one idea at a time:
  1. variables and strings (storing a DNA sequence)
  2. a function that computes GC content (the clean version of yesterday's Bash hack)
  3. a function that reverse-complements a sequence
  4. a function that transcribes DNA -> RNA

Nothing here needs Biopython — it is plain Python so you can see every step.
"""

# ----------------------------------------------------------------------
# 1. A variable is a labelled box. Here we store a DNA sequence (a string).
#    A string is just text wrapped in quotes.
# ----------------------------------------------------------------------
dna = "ATGCGTACGTTAGCCGGGCATTAGC"

print("Sequence:", dna)
print("Length  :", len(dna))   # len() counts the characters = number of bases


# ----------------------------------------------------------------------
# 2. GC content. Yesterday in Bash this took grep | grep -o | wc -l | awk.
#    In Python it is a few readable lines inside a reusable function.
#
#    'def' defines a function. Everything indented below it is the recipe.
#    'return' hands a value back to whoever called the function.
# ----------------------------------------------------------------------
def gc_content(seq):
    """Return the percentage of G and C bases in seq (0-100)."""
    seq = seq.upper()                 # make it case-insensitive
    g = seq.count("G")                # .count() counts a character
    c = seq.count("C")
    return (g + c) / len(seq) * 100   # the percentage


# ----------------------------------------------------------------------
# 3. Reverse complement. DNA is double-stranded; the complement pairs
#    A<->T and G<->C, and we read the other strand backwards.
# ----------------------------------------------------------------------
def reverse_complement(seq):
    """Return the reverse complement of a DNA sequence."""
    seq = seq.upper()
    # A dictionary maps each base to its partner.
    pairs = {"A": "T", "T": "A", "G": "C", "C": "G"}
    # Build the complement base by base, then reverse with [::-1].
    complement = ""
    for base in seq:
        complement = complement + pairs[base]
    return complement[::-1]           # [::-1] reverses a string


# ----------------------------------------------------------------------
# 4. Transcription: DNA -> RNA. Biologically, T is replaced by U.
# ----------------------------------------------------------------------
def transcribe(seq):
    """Return the RNA version of a DNA sequence (T -> U)."""
    return seq.upper().replace("T", "U")


# ----------------------------------------------------------------------
# Use the functions. This block runs when you execute the file directly.
# ----------------------------------------------------------------------
if __name__ == "__main__":
    print()
    print("GC content        :", round(gc_content(dna), 2), "%")
    print("Reverse complement:", reverse_complement(dna))
    print("Transcribed (RNA) :", transcribe(dna))

    # Functions are reusable — call them on a different sequence for free.
    print()
    other = "GGGGCCCCAAAATTTT"
    print("Second sequence   :", other)
    print("  GC content      :", round(gc_content(other), 2), "%")
    print("  Reverse comp    :", reverse_complement(other))
