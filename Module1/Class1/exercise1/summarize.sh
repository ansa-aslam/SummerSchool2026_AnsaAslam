#!/bin/bash
for file in ~/SummerSchool2026-main/Module1/data/*.fasta
do
	echo "$file has $(grep -v '^>' "$file" | wc -c ) has sequence characters"
done
