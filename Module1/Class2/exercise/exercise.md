# Class 2 — Exercises
**Python Programming Fundamentals**

Work inside the `Class_2_Python_Fundamentals/code/` folder so the relative path `../../data/<file>` finds the datasets. Write your code into a script called `class2_answers.py` as you go, and run it with:
```bash
python3 class2_answers.py
```

---

## Part A — Variables, types, operators
1. Create three variables: `gene = "recA"`, `length = 1500`, `gc = 52.47`. Print a sentence like `recA is 1500 bp with 52.47% GC` using `print()`.
2. Print the `type()` of each of the three variables above.
3. A codon is 3 bases. Using the `%` (modulo) operator, print whether `length = 1500` is an exact number of whole codons (i.e. divisible by 3). (Hint: `1500 % 3 == 0`.)
4. Given `seq = "ATGCGT"`, print its length, its reverse (`seq[::-1]`), and its first three bases (a slice).
