#!/usr/bin/env bash
# summarize.sh — count sequences and sequence characters in every FASTA file in a folder
# Usage: ./summarize.sh <folder>

folder="$1"
if [ -z "$folder" ]; then
    echo "Usage: $0 <folder>"
    exit 1
fi

echo "Summarizing FASTA files in: $folder"
echo "-----------------------------------"

for file in "$folder"/*.fasta
do
    [ -e "$file" ] || continue
    count=$(grep -c ">" "$file")
    chars=$(grep -v ">" "$file" | tr -d '\n' | wc -c)
    echo "$file has $count sequences and $chars sequence characters"
done

echo "-----------------------------------"
echo "Done."
