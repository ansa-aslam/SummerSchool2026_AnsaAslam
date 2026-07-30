#!/bin/bash
echo "$1 has feature counts"
cut -f3 "$1" | grep -E '^(gene|mRNA|exon)$' | sort |uniq -c
