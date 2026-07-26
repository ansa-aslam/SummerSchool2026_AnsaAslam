# Install WSL on Windows 11 (Quick Guide)

This short guide shows recommended steps to install Windows Subsystem for Linux (WSL) on Windows 11.

Prerequisites
- Windows 11 (up-to-date). WSL2 requires Virtualization support (most modern PCs have this).
- Administrator access to run PowerShell commands.

Recommended (one-line) install
1. Open PowerShell *as Administrator*.
2. Run:

```
wsl --install
```

This command enables required Windows features, installs the WSL2 kernel, and installs the default Linux distribution (usually Ubuntu). Reboot if prompted.

Install a specific distribution
- List available distros: `wsl --list --online`
- Install e.g. Ubuntu 22.04:

```
wsl --install -d Ubuntu-22.04
```

Set WSL2 as default

```
wsl --set-default-version 2
```

If you already have a distro and want to convert it:

```
wsl --set-version <DistroName> 2
```

Check WSL status

```
wsl --status
```

Manual steps (if `wsl --install` fails)
1. Enable features (PowerShell as Admin):

```
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
```

2. Download and install the Linux kernel update package (if prompted):
   https://aka.ms/wsl2kernel
3. Reboot your PC.
4. Install a distro from the Microsoft Store (search "Ubuntu", "Debian", etc.) or use `wsl --install -d <Name>`.

Post-install tips
- Consider installing Windows Terminal from Microsoft Store for a better terminal experience.
- Launch your Ubuntu distro from *Windows Terminal*.
- Create a `UNIX username` and `password` when prompted.
- Update packages inside the distro:

```
sudo apt update && sudo apt upgrade -y
```

Troubleshooting
- If virtualization appears disabled, enable it in your BIOS/UEFI settings (look for Intel VT-x or AMD-V).
- For detailed official docs and latest instructions, see: https://learn.microsoft.com/windows/wsl/install

Security note
- Keep Windows and the Linux distro updated. Use care when running commands downloaded from the internet.

## Video tutorial

Guide: https://youtu.be/JzSZhdptuTs?si=WjYgxYMsPrIrUuQU

