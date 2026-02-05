# macOS Setup Guide

Automated development environment setup for macOS.

## ✨ Features

- 🎨 **Beautiful colored output** with progress indicators
- 🔧 **Modular scripts** - run individually or all at once
- 🤖 **Automatic configuration** - Zsh config applied automatically
- 🔒 **Safe updates** - Creates backups before modifying files
- 🍺 **Homebrew-based** - Uses the standard macOS package manager

## 📋 What Gets Installed

- **Homebrew** - macOS package manager
- **Zsh & Oh My Zsh** - Modern shell with plugins (zsh-z, autosuggestions, syntax-highlighting)
- **Node.js & NVM** - Node Version Manager with the latest Node.js, Yarn, and Angular CLI
- **GitHub SSH Keys** - SSH key generation and GitHub configuration
- **Docker Desktop** - Docker for Mac

## 🚀 Quick Start

### Prerequisites

- macOS 11+ (Big Sur or later)
- Internet connection
- Xcode Command Line Tools (will be installed automatically by Homebrew)

### Run Full Setup

```bash
cd scripts/macOS
bash setup.sh
```

This will run all installation scripts in sequence.

## 📦 Individual Installation Scripts

You can also run individual installation scripts independently:

### Install Homebrew

```bash
bash scripts/macOS/installations/install-homebrew.sh
```

Installs Homebrew package manager for macOS. Automatically handles Apple Silicon (M1/M2/M3) configuration.

### Install Zsh & Oh My Zsh

```bash
bash scripts/macOS/installations/install-zsh.sh
```

Installs Zsh, Oh My Zsh, plugins, and applies your custom Zsh configuration from `zsh-config.sh`.

### Install Node.js & NVM

```bash
bash scripts/macOS/installations/install-node.sh
```

Installs NVM, the latest Node.js, Yarn, and Angular CLI.

### Setup GitHub SSH

```bash
bash scripts/macOS/installations/install-github-ssh.sh
```

Generates SSH keys for GitHub and configures SSH config. Your public key will be displayed at the end.

### Install Docker Desktop

```bash
bash scripts/macOS/installations/install-docker.sh
```

Installs Docker Desktop for Mac via Homebrew. Requires manual startup from Applications.

## ⚙️ Configuration Files

### `scripts/macOS/zsh-config.sh`

Your custom Zsh configuration with:

- Custom aliases for Git, Docker, Node.js, Python
- Functions for SSH key generation, Python virtual environments
- Homebrew path configuration (including Apple Silicon support)
- Homebrew shortcuts (`brewup` for update/upgrade/cleanup)

This file is automatically copied to `~/.zshrc` during Zsh installation.

### `scripts/macOS/utils/`

Utility scripts:

- `colors.sh` - Color definitions and print functions for beautiful terminal output

## 📝 Post-Installation Steps

After running the setup:

1. **Restart your terminal** - Required for Zsh changes to take effect

2. **Verify Zsh configuration** - Configuration is automatically applied! Just open a new terminal

3. **Add SSH key to GitHub**:

   ```bash
   cat ~/.ssh/personal.pub
   ```

   Copy the output and add it to [GitHub SSH Keys](https://github.com/settings/keys)

4. **Start Docker Desktop** - Open from Applications folder

5. **Verify Docker**:

   ```bash
   docker --version
   docker compose version
   ```

6. **(Optional) Install Powerlevel10k theme**:
   ```bash
   git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
   ```
   Then update `ZSH_THEME="powerlevel10k/powerlevel10k"` in `~/.zshrc`

## 🛠️ Customization

### Modify Zsh Configuration

Edit `scripts/macOS/zsh-config.sh` with your preferences before running the installation, or modify `~/.zshrc` after installation.

### Add More Installation Steps

1. Create a new script in `scripts/macOS/installations/`
2. Follow the naming pattern: `install-<component>.sh`
3. Add the script call to `scripts/macOS/setup.sh`

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
2. Combine shared and macOS-specific configurations
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

### Homebrew

- `brewup` - Update, upgrade, and cleanup Homebrew packages

## 🐛 Troubleshooting

### Homebrew command not found

If `brew` command isn't found after installation:

**Intel Mac:**

```bash
eval "$(/usr/local/bin/brew shellenv)"
```

**Apple Silicon Mac:**

```bash
eval "$(/opt/homebrew/bin/brew shellenv)"
```

Then restart your terminal.

### Docker Desktop not starting

1. Open Docker Desktop manually from Applications
2. Grant required permissions when prompted
3. Wait for Docker to fully start (whale icon in menu bar should be steady)

### Zsh configuration not applied

If your custom aliases don't work:

```bash
# Reload configuration
source ~/.zshrc

# Or check if config was copied
cat ~/.zshrc | grep "zsh-z"
```

### Permission issues with npm global packages

If you get EACCES errors when installing npm packages globally:

```bash
mkdir ~/.npm-global
npm config set prefix '~/.npm-global'
echo 'export PATH=~/.npm-global/bin:$PATH' >> ~/.zshrc
source ~/.zshrc
```

### NVM not found after installation

```bash
# Add to ~/.zshrc if not already there
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
```

---

[← Back to Main README](../README.md)
