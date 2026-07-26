# Class 4 — Exercises
**Package Management with Conda and Mamba**

Work in your terminal and write your answers into a file called `class4_answers.txt` as you go:

```bash
nano class4_answers.txt
```

If you are not already inside the course folder, move to `Module1/Class4/` first.

---

## Part A — Concept check
1. In one or two sentences, explain the difference between conda and mamba.
2. Why is it a bad idea to install all packages into the system Python?
3. What is an environment, in your own words?

## Part B — Installation and setup
4. Write the command you would use on Ubuntu to install mamba into an existing conda setup.
5. Show the command that checks whether mamba is installed and prints its version.
6. Write the command that adds `conda-forge` as a channel and enables strict channel priority.

## Part C — Creating and removing environments
7. Create a new environment called `bioinfo` with Python 3.11. Write the exact command.
8. Write the command to activate that environment.
9. Write the command to show all environments and identify which one is active.
10. Write the command to remove the `bioinfo` environment.

## Part D — Installing packages
11. In the `bioinfo` environment, install `numpy`, `pandas`, and `biopython`.
12. Write a one-line command that imports `numpy`, `pandas`, and `Bio` and prints each version.
13. Remove `pandas` from the environment without deleting the whole environment.

## Part E — Version pinning
14. Create a new environment called `pinned_env` that pins these exact versions: Python 3.11, numpy 1.26.4, pandas 2.2.2, biopython 1.83.
15. Write the contents of an `environment.yml` file that would recreate the same environment.
16. Write the command that exports the current environment to `pinned_env.yml` without build numbers.

## Part F — Practice with reproducibility
17. Explain the difference between installing a package with no version pin and installing it with `numpy=1.26.4`.
18. Why might two students get different results if they both run `mamba install numpy` on different days?
19. What should you do before sharing your environment with someone else?

## 🚀 Challenge (optional)
20. Create an environment called `qc_tools` with Python 3.11 and the packages `fastqc`, `multiqc`, and `pandas`. Write the command you used.
21. Save a reproducible environment file for `qc_tools` and write the command you would use to recreate it later.
22. Write one short paragraph about when you would choose mamba over conda, and when the difference does not matter much.

---
### Submit
Save `class4_answers.txt`.