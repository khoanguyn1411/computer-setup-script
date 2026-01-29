# Computer Setup Script

Automated development environment setup scripts for Ubuntu/WSL2. This repository contains modular installation scripts to quickly configure a complete development environment with Zsh, Node.js, Docker, and IDE launchers.

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
- **IDE Launchers** - Windsurf and Antigravity WSL remote launchers
- **WSL Optimization** - Memory and processor configuration (WSL only)

## 🚀 Quick Start

### Prerequisites

- Ubuntu 22.04+ or WSL2 with Ubuntu
- `sudo` privileges
- Internet connection

### Run Full Setup

```bash
cd ubuntu
bash setup.sh
```

This will run all installation scripts in sequence.

## 📦 Individual Installation Scripts

You can also run individual installation scripts independently:

### Install Zsh & Oh My Zsh

```bash
bash ubuntu/installations/install-zsh.sh
```

Installs Zsh, Oh My Zsh, plugins, and applies your custom Zsh configuration from `zsh-config.sh`.

### Install Node.js & NVM

```bash
bash ubuntu/installations/install-node.sh
```

Installs NVM, the latest Node.js, Yarn, and Angular CLI.

### Setup GitHub SSH

```bash
bash ubuntu/installations/install-github-ssh.sh
```

Generates SSH keys for GitHub and configures SSH config. Your public key will be displayed at the end.

### Install Docker

```bash
bash ubuntu/installations/install-docker.sh
```

Installs Docker Engine, Docker CLI, and Docker Compose plugin. Adds your user to the docker group.

### Setup Windsurf Launcher

```bash
bash ubuntu/installations/install-windsurf.sh
```

Creates a launcher script for opening folders in Windsurf via WSL remote connection.

### Setup Antigravity Launcher

```bash
bash ubuntu/installations/install-antigravity.sh
```

Creates a launcher script for opening folders in Antigravity via WSL remote connection.

### Update WSL Config (WSL Only)

```bash
bash ubuntu/installations/update-wslconfig.sh
```

Optimizes WSL performance by configuring:

- Memory: 32GB
- Processors: 12

Automatically detects if running in WSL and skips on native Ubuntu. Creates a backup before modifying `.wslconfig`.

## ⚙️ Configuration Files

### `ubuntu/zsh-config.sh`

Your custom Zsh configuration with:

- Custom aliases for Git, Docker, Node.js, Python
- Functions for SSH key generation, Python virtual environments
- IDE launcher shortcuts (`wf` for Windsurf, `ag` for Antigravity)

This file is automatically copied to `~/.zshrc` during Zsh installation.

### `ubuntu/launchers/`

Contains launcher scripts:

- `windsurf-launcher.sh` - Open folders in Windsurf
- `antigravity-launcher.sh` - Open folders in Antigravity

### `ubuntu/utils/`

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

Edit `ubuntu/zsh-config.sh` with your preferences before running the installation, or modify `~/.zshrc` after installation.

### Add More Installation Steps

1. Create a new script in `ubuntu/installations/`
2. Follow the naming pattern: `install-<component>.sh`
3. Add the script call to `ubuntu/setup.sh`

## 🔧 Useful Commands (from Zsh config)

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

- `wf <path>` - Open path in Windsurf
- `ag <path>` - Open path in Antigravity

## 📄 License

MIT License - feel free to use and modify as needed.

## 🤝 Contributing

Feel free to submit issues or pull requests for improvements!
