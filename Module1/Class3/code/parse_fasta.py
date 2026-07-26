#!/usr/bin/env python3
"""
parse_fasta.py — read a FASTA file WITHOUT Biopython.

We do it "by hand" first so you understand exactly what a FASTA parser does.
Tomorrow Biopython will do this for you in one line — but today you build it,
so the magic is never a mystery.

Run it with the default genes file:
    python3 parse_fasta.py

Or point it at any FASTA file:
    python3 parse_fasta.py ../../data/ecoli_genome.fasta
"""

import sys   # 'sys' lets us read command-line arguments (like $1 in Bash)


def gc_content(seq):
    """Return GC percentage of a sequence (0-100)."""
    seq = seq.upper()
    return (seq.count("G") + seq.count("C")) / len(seq) * 100


def read_fasta(path):
    """
    Read a FASTA file and return a dictionary {sequence_id: sequence}.

    A FASTA file looks like:
        >id1 some description
        ACGT...
        ACGT...
        >id2 ...
        ...
    Header lines start with '>'. Everything else is sequence, possibly
    split across several lines, which we must glue back together.
    """
    sequences = {}          # an empty dictionary to fill in
    current_id = None       # which record are we currently reading?

    # 'with open(...)' opens the file and closes it automatically at the end.
    with open(path) as handle:
        for line in handle:
            line = line.strip()         # remove the trailing newline
            if line == "":
                continue                # skip blank lines
            if line.startswith(">"):
                # New record. Take the first word of the header as the id.
                current_id = line[1:].split()[0]   # drop '>', keep first word
                sequences[current_id] = ""         # start with empty sequence
            else:
                # A sequence line — add it to the current record.
                sequences[current_id] += line
    return sequences


def main():
    # If the user passed a path, use it; otherwise use the genes file.
    if len(sys.argv) > 1:
        path = sys.argv[1]
    else:
        path = "../../data/genes.fasta"

    print("Reading FASTA file:", path)
    print("-" * 55)

    records = read_fasta(path)

    # Loop over the dictionary: .items() gives (key, value) pairs.
    total_length = 0
    for seq_id, seq in records.items():
        length = len(seq)
        total_length += length
        print(f"{seq_id:<8} length={length:>6}   GC={gc_content(seq):.2f}%")

    print("-" * 55)
    print(f"Number of sequences : {len(records)}")
    print(f"Total bases         : {total_length}")
    print(f"Average length      : {total_length / len(records):.1f} bp")


if __name__ == "__main__":
    main()
