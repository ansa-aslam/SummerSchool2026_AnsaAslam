#!/usr/bin/env bash
# count_features.sh — tally gene/mRNA/exon counts from a GFF3 file
# Usage: ./count_features.sh <annotations.gff3>

file="$1"
if [ -z "$file" ]; then
    echo "Usage: $0 <annotations.gff3>"
    exit 1
fi

awk 'BEGIN{genes=0;mrna=0;exon=0}
/^#/ {next}
{ if($3=="gene") genes++; else if($3=="mRNA") mrna++; else if($3=="exon") exon++ }
END{print "gene " genes; print "mRNA " mrna; print "exon " exon}' "$file"
