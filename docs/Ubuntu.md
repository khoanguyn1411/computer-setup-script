# Ubuntu/WSL2 Setup Guide

Automated development environment setup for Ubuntu and WSL2.

## ✨ Features

- 🎨 **Beautiful colored output** with progress indicators
- 🔧 **Modular scripts** - run individually or all at once
- 🤖 **Automatic configuration** - Zsh config applied automatically
- 🔒 **Safe updates** - Creates backups before modifying files
- 🪟 **WSL optimization** - Automatic WSL config tuning (WSL only)

## 📋 What Gets Installed

- **Zsh & Oh My Zsh** - Modern shell with plugins (zsh-z, autosuggestions, syntax-highlighting)
- **Node.js & NVM** - Node Version Manager with the latest Node.js, Yarn, and Angular CLI
- **GitHub SSH Keys** - SSH key generation and GitHub configuration
- **Docker** - Docker Engine, CLI, and Docker Compose plugin
- **IDEs** - VS Code, Windsurf, Antigravity (native Ubuntu only)
- **IDE Launchers** - Windsurf and Antigravity WSL remote launchers (WSL only)
- **WSL Optimization** - Memory and processor configuration (WSL only)

## 🚀 Quick Start

### Prerequisites

- Ubuntu 22.04+ or WSL2 with Ubuntu
- `sudo` privileges
- Internet connection

### Run Full Setup

```bash
cd scripts/ubuntu
bash setup.sh
```

This will run all installation scripts in sequence.

## 📦 Individual Installation Scripts

You can also run individual installation scripts independently:

### Install Zsh & Oh My Zsh

```bash
bash scripts/ubuntu/installations/install-zsh.sh
```

Installs Zsh, Oh My Zsh, plugins, and applies your custom Zsh configuration from `zsh-config.sh`.

### Install Node.js & NVM

```bash
bash scripts/ubuntu/installations/install-node.sh
```

Installs NVM, the latest Node.js, Yarn, and Angular CLI.

### Setup GitHub SSH

```bash
bash scripts/ubuntu/installations/install-github-ssh.sh
```

Generates SSH keys for GitHub and configures SSH config. Your public key will be displayed at the end.

### Install Docker

```bash
bash scripts/ubuntu/installations/install-docker.sh
```

Installs Docker Engine, Docker CLI, and Docker Compose plugin. Adds your user to the docker group.

### Install IDEs (VSCode, Windsurf, Antigravity)

```bash
bash scripts/ubuntu/installations/install-ide.sh
```

Installs VS Code, Windsurf, and Antigravity on native Ubuntu. Launcher scripts are also created automatically on WSL systems.

**For WSL users:** This script will skip installation and provide download links for Windows. IDEs should be installed on the Windows side and accessed via WSL remote features. Launchers are configured automatically.


### Update WSL Config (WSL Only)

```bash
bash scripts/ubuntu/installations/update-wslconfig.sh
```

Optimizes WSL performance by configuring:

- Memory: 32GB
- Processors: 12

Automatically detects if running in WSL and skips on native Ubuntu. Creates a backup before modifying `.wslconfig`.

## ⚙️ Configuration Files

### `scripts/ubuntu/zsh-config.sh`

Your custom Zsh configuration with:

- Custom aliases for Git, Docker, Node.js, Python
- Functions for SSH key generation, Python virtual environments
- IDE launcher shortcuts (`wf` for Windsurf, `ag` for Antigravity)

This file is automatically copied to `~/.zshrc` during Zsh installation.

### `scripts/ubuntu/launchers/`

Contains launcher scripts for WSL:

- `windsurf-launcher.sh` - Open folders in Windsurf via WSL remote
- `antigravity-launcher.sh` - Open folders in Antigravity via WSL remote

### `scripts/ubuntu/utils/`

Utility scripts:

- `colors.sh` - Color definitions and print functions for beautiful terminal output

## 📝 Post-Installation Steps

After running the setup:

1. **Log out and log back in** - Required for Zsh shell change and Docker group permissions

2. **Verify Zsh configuration** - Configuration is automatically applied! Just open a new terminal

3. **Add SSH key to GitHub**:

   ```bash
   cat ~/.ssh/personal.pub
   ```

   Copy the output and add it to [GitHub SSH Keys](https://github.com/settings/keys)

4. **Verify Docker** (after re-login):

   ```bash
   docker --version
   docker compose version
   ```

5. **(WSL Only) Restart WSL** for config changes to take effect:

   ```powershell
   # Run in PowerShell
   wsl --shutdown
   ```

   Then restart your WSL terminal

6. **(Optional) Install Powerlevel10k theme**:
   ```bash
   git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
   ```
   Then update `ZSH_THEME="powerlevel10k/powerlevel10k"` in `~/.zshrc`

## 🛠️ Customization

### Modify Zsh Configuration

Edit `scripts/ubuntu/zsh-config.sh` with your preferences before running the installation, or modify `~/.zshrc` after installation.

### Add More Installation Steps

1. Create a new script in `scripts/ubuntu/installations/`
2. Follow the naming pattern: `install-<component>.sh`
3. Add the script call to `scripts/ubuntu/setup.sh`

## 🔧 Useful Commands (from Zsh config)

### Zsh Management

- `zshConfig` - Open ~/.zshrc in VS Code
- `zshRestart` - Reload Zsh configuration
- `zshUpdate` - Auto-update Zsh config from GitHub repo
- `zshHistoryFix` - Fix corrupted Zsh history

#### zshUpdate - Keep Your Configuration Up-to-Date

The `zshUpdate` command automatically pulls the latest configuration from your GitHub repository and updates your `~/.zshrc`:

```bash
zshUpdate
```

This will:
1. Clone the latest version of your setup repository
2. Combine shared and Ubuntu-specific configurations
3. Update your `~/.zshrc` file
4. Reload your shell configuration
5. Clean up temporary files

No need to manually manage configuration files anymore!

### Git Aliases

- `gc "message"` - Git commit with message
- `gp` - Git push
- `gpl` - Git pull
- `gck branch` - Git checkout branch
- `gacp "message"` - Git add, commit, and push
- `sd` - Sync with develop branch

### Docker

- `dockerCleanAll` - Clean all Docker resources

### Python

- `initPython` - Create venv and install requirements
- `av` - Activate virtual environment
- `py` - Python3 shortcut

### IDE Launchers

#### Quick Reference

- `wf [path]` - Open path in Windsurf (defaults to current directory if no path provided)
- `ag [path]` - Open path in Antigravity (defaults to current directory if no path provided)

#### How IDE Shortcuts Work

The `wf` and `ag` shortcuts are automatically configured during the Zsh installation and adapt based on your environment:

**On Native Ubuntu:**
- Launches the IDE application directly with the specified path
- Works similarly to how `code` opens Visual Studio Code
- Example: `wf .` opens Windsurf in the current directory
- Example: `ag ~/projects/myapp` opens Antigravity with that specific folder

**On WSL:**
- Uses WSL remote connection features to open folders from WSL in Windows-installed IDEs
- Automatically detects the WSL distribution name
- Opens the IDE with proper remote connection URI

#### Setup Instructions

The shortcuts are automatically configured in your `~/.zshrc` when you run the setup script.

**For Bash users**, if you want to manually add these shortcuts to your `.bashrc`:

1. Open your `.bashrc` file:
   ```bash
   nano ~/.bashrc
   ```

2. Add the following at the end:
   ```bash
   # IDE shortcuts
   if grep -qi microsoft /proc/version 2>/dev/null || [ -n "$WSL_DISTRO_NAME" ]; then
       # WSL: Use launcher scripts
       alias wf="source ~/windsurf-launcher.sh"
       alias ag="source ~/antigravity-launcher.sh"
   else
       # Native Ubuntu: Launch applications directly
       function wf() {
           if ! command -v windsurf &> /dev/null; then
               echo "Error: windsurf is not installed"
               return 1
           fi
           local target_path="${1:-.}"
           windsurf "$target_path" &> /dev/null &
       }
       
       function ag() {
           if ! command -v antigravity &> /dev/null; then
               echo "Error: antigravity is not installed"
               return 1
           fi
           local target_path="${1:-.}"
           antigravity "$target_path" &> /dev/null &
       }
   fi
   ```

3. Reload your configuration:
   ```bash
   source ~/.bashrc
   ```

**Note:** Zsh users get these shortcuts automatically configured during setup. No manual configuration needed!

## 🐛 Troubleshooting

### Docker permission denied

If you get permission errors with Docker after installation:

```bash
# Log out and log back in, or restart WSL
wsl --shutdown  # Run in PowerShell
```

### Zsh not default shell

If Zsh isn't your default shell after installation:

```bash
chsh -s $(which zsh)
```

### WSL config not applied

If WSL performance settings aren't working:

1. Make sure you shut down WSL completely: `wsl --shutdown` (in PowerShell)
2. Check `.wslconfig` exists: `cat /mnt/c/Users/<YourUsername>/.wslconfig`
3. Restart WSL and verify with: `free -h` (check memory) and `nproc` (check processors)

---

[← Back to Main README](../README.md)
