# Install R 4.5.3 and RStudio Desktop

This short guide shows how to install R 4.5.3 and RStudio Desktop on Linux and Windows.

## Linux

1. Open the official CRAN Linux pages:
   https://cran.r-project.org/bin/linux/
2. Use the distro instructions for your system, then install R from CRAN.
   - Ubuntu / Debian users should follow the `.deb` instructions.
   - Fedora / RHEL / SUSE users should follow the matching package instructions.
3. If you need the exact 4.5.3 release, use the source archive:

```text
https://cran.r-project.org/src/base/R-4/R-4.5.3.tar.gz
```

4. Download and Install it in the system. After installation, Check that R installed correctly:

```bash
R --version
```

5. Install RStudio Desktop from Posit:
   https://docs.posit.co/ide/user/#rstudio-ide-oss-downloads
6. Download the Linux package that matches your system and install it.
   - Ubuntu / Debian usually use `.deb`
   - Fedora / RHEL usually use `.rpm`

## Windows

1. Download R 4.5.3 from the CRAN Windows archive:
   https://cran.r-project.org/bin/windows/base/old/4.5.3/
2. Run the installer and keep the default options.
3. Open R from the Start menu and confirm the version:

```r
version
```

4. Download RStudio Desktop for Windows from Posit:
   https://docs.posit.co/ide/user/#rstudio-ide-oss-downloads
5. Run the Windows installer and keep the default settings.

## Quick check

Open RStudio and run:

```r
install.packages("tidyverse")
library(tidyverse)
```

If the package installs and loads, your setup is ready.

## Notes

- Use the official CRAN and Posit download pages only.
- If your computer already has R installed, you may see more than one version on the system.