# Class 4 — Package Management with Conda and Mamba
## Student Workbook
**Theme: Reproducible Python environments for bioinformatics**

> 📖 **How to use this workbook.** Read along and **type every `⌨️` block yourself**. Today is about building environments you can recreate later, not just installing random packages into the base system.

---

## Today you will learn to
- Explain the difference between **conda** and **mamba**.
- Install mamba on Ubuntu.
- Create, list, activate, and remove environments.
- Install packages into an environment.
- Pin exact package versions so a setup can be reproduced.

---

## 1. Why package managers matter

Bioinformatics tools often depend on specific versions of Python, libraries, and command-line programs. If everyone installs into the same global system, one update can break another project.

The fix is to use **isolated environments**.

- A **base environment** is the default installation that ships with the package manager.
- An **environment** is a separate workspace with its own Python and packages.
- Reproducibility means you can say, “use Python 3.11 with these exact package versions,” and get the same setup again later.

💡 The important habit: **do not install course packages into the system Python**. Put them in a named environment.

---

## 2. Conda vs mamba

Both tools manage environments and packages, and both understand the same ecosystem of package metadata and channels.

| Tool | What it is | Why use it |
|---|---|---|
| `conda` | the original package and environment manager | widely known, built into Anaconda and Miniconda |
| `mamba` | a faster drop-in replacement for many conda commands | faster dependency solving, same workflow for most tasks |

### The practical difference
- **Conda** solves dependencies more slowly on large environments.
- **Mamba** uses a faster solver, so it usually installs and resolves packages much quicker.
- In practice, you can often use the same commands with `mamba` instead of `conda`.

💡 Think of it this way: conda is the familiar tool, mamba is the quicker tool with the same shape.

---

## 3. Install mamba from Scratch on Ubuntu 

There are a few ways to get mamba. In this course, the simplest path is:

1. Install Miniconda or Mambaforge if you do not already have conda.
2. Install mamba into the base environment, or use a distribution that already includes it.

On Ubuntu Terminal:

⌨️
```bash
wget "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-x86_64.sh"

chmod + x Miniforge3-Linux-x86_64.sh

bash Miniforge3-Linux-x86_64.sh
```

Close the Terminal and restart it. You will see: (base) written before your username on termianl. 

✅ Check that the command exists:

```bash
mamba --version
conda --version
```

> ⚠️ If your terminal says a command is not found, your shell may need to be restarted or conda may not yet be initialized.

---

## 4. Channels and package sources

Packages come from **channels**, which are online collections of package builds.

Common ones:
- `conda-forge` is the community channel we will use most often.
- `defaults` is the default Anaconda channel.

⌨️
```bash
conda config --show channels
conda config --add channels bioconda
conda config --set channel_priority strict
```

💡 Strict channel priority helps avoid mixing incompatible builds from different sources.

---

## 5. Create an environment

An environment usually gets a name and a Python version.

⌨️ Create a new environment called `bioinfo` with Python 3.11:
```bash
mamba create -n bioinfo python=3.11
```

You will usually be asked to confirm the plan. Type `y`.

Then activate it:

```bash
conda activate bioinfo
```

Check that you are inside the new environment:

```bash
which python
python --version
conda info --envs
```

✅ The active environment should have an asterisk next to `bioinfo`.

---

## 6. Install packages into an environment

Once the environment is active, install packages there, not globally.

⌨️
```bash
mamba install numpy pandas biopython
```

Check what was installed:

```bash
python -c "import numpy, pandas, Bio; print(numpy.__version__); print(pandas.__version__); print(Bio.__version__)"
```

💡 `mamba install` resolves and downloads packages into the active environment. If you want to be explicit, you can also target a named environment with `-n bioinfo`.

---

## 7. Remove packages and remove environments

Sometimes you want to clean up a package, or delete the whole environment and start over.

To remove one package from the active environment:

```bash
mamba remove pandas
```

To remove an entire environment:

```bash
conda deactivate
mamba env remove -n bioinfo
```

✅ After removal, `conda info --envs` should no longer list `bioinfo`.

> ⚠️ Removing an environment deletes everything inside it. If you need the setup later, export it first.

---

## 8. Pin exact versions

Reproducibility depends on version pinning.

You can pin versions directly when you install:

⌨️
```bash
mamba create -n pinned_env python=3.11 numpy=1.26.4 biopython=1.83 pandas=2.2.2
```

You can also record the exact setup in a file.

### Option A: environment.yml

```yaml
name: pinned_env
channels:
  - conda-forge
dependencies:
  - python=3.11
  - numpy=1.26.4
  - pandas=2.2.2
  - biopython=1.83
```

Then create the environment from the file:

```bash
mamba env create -f environment.yml
```

### Option B: explicit exports

```bash
conda env export --no-builds > environment.yml
```

That file can be shared with classmates or future you.

💡 Exact pins like `numpy=1.26.4` are more reproducible than “latest available.” For long-lived projects, that matters a lot.

---

## 9. Freeze what you have

If you already built a working environment, export it before changing anything.

⌨️
```bash
conda activate pinned_env
conda list
conda env export --no-builds > pinned_env.yml
```

Later, someone can recreate the same environment from that file.

---

## 10. Best practices for this course

- Use one environment per project or per class.
- Keep the environment name simple and descriptive.
- Be cautious of the empty spaces in the commands and env names! `(They can be disatrous!)`
- Pin versions when the exact software stack matters.
- Remove environments you no longer use.

---

## ✅ End-of-class self-check
Tick these before you leave:
- [ ] I can explain the difference between conda and mamba.
- [ ] I can install mamba on Ubuntu, or I know how my distribution provides it.
- [ ] I can create and activate a named environment.
- [ ] I can install packages into that environment.
- [ ] I can remove a package and remove the whole environment.
- [ ] I can pin exact package versions in a command or in an environment.yml file.

## One-line summary to remember
**mamba solves faster; conda manages the ecosystem; environments keep projects isolated; version pins keep them reproducible.**

➡️ Now do `exercise/exercise.md`.