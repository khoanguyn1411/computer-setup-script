# Computer Setup Script

Automated development environment setup scripts for **Ubuntu/WSL2** and **macOS**. This repository contains modular installation scripts to quickly configure a complete development environment with Zsh, Node.js, Docker, and IDE launchers.

## ✨ Features

- 🎨 **Beautiful colored output** with progress indicators
- 🔧 **Modular scripts** - run individually or all at once
- 🤖 **Automatic configuration** - Zsh config applied automatically
- 🔒 **Safe updates** - Creates backups before modifying files
- 🪟 **WSL optimization** - Automatic WSL config tuning (WSL only)
- 🍎 **macOS support** - Homebrew-based setup for Mac users

## � Documentation

Choose your platform for detailed setup instructions:

- **[Ubuntu/WSL2 Setup Guide](docs/Ubuntu.md)** - Complete guide for Ubuntu and Windows Subsystem for Linux
- **[macOS Setup Guide](docs/MacOS.md)** - Complete guide for Mac users

## 🚀 Quick Start

### Ubuntu/WSL2

```bash
cd scripts/ubuntu
bash setup.sh
```

**Prerequisites:** Ubuntu 22.04+, sudo privileges, internet connection

[📖 Full Ubuntu/WSL2 Documentation →](docs/Ubuntu.md)

### macOS

```bash
cd scripts/macOS
bash setup.sh
```

**Prerequisites:** macOS 11+ (Big Sur or later), internet connection

[📖 Full macOS Documentation →](docs/MacOS.md)

## 📋 What Gets Installed

### Ubuntu/WSL2

- Zsh & Oh My Zsh with plugins
- Node.js & NVM
- GitHub SSH Keys
- Docker Engine
- IDE Launchers (Windsurf, Antigravity)
- WSL Performance Optimization

### macOS

- Homebrew
- Zsh & Oh My Zsh with plugins
- Node.js & NVM
- GitHub SSH Keys
- Docker Desktop

## 🔧 Quick Commands Reference

### Git Aliases

```bash
gc "message"       # Git commit
gp                 # Git push
gpl                # Git pull
gacp "message"     # Add, commit, and push
```

### Docker

```bash
dockerCleanAll     # Clean all Docker resources
```

### Python

```bash
initPython         # Create venv and install requirements
av                 # Activate virtual environment
```

### IDE Shortcuts (Ubuntu/WSL only)

```bash
wf [path]          # Open path in Windsurf (defaults to current directory)
ag [path]          # Open path in Antigravity (defaults to current directory)
```

**Note:** These shortcuts automatically adapt based on your environment:

- **Native Ubuntu**: Launches the IDE directly with the specified path
- **WSL**: Opens the path using WSL remote connection features

### Homebrew (macOS only)

```bash
brewup             # Update, upgrade, and cleanup
```

## 📂 Repository Structure

```
.
├── scripts/                  # Platform-specific setup scripts
│   ├── ubuntu/               # Ubuntu/WSL2 setup
│   │   ├── setup.sh          # Main setup script
│   │   ├── zsh-config.sh     # Ubuntu-specific Zsh config
│   │   ├── installations/    # Individual install scripts
│   │   └── launchers/        # WSL launcher scripts
│   └── macOS/                # macOS setup
│       ├── setup.sh          # Main setup script
│       ├── zsh-config.sh     # macOS-specific Zsh config
│       └── installations/    # Individual install scripts
├── shared/                   # Shared configurations
│   ├── zsh-config.sh         # Common Zsh configuration
│   └── colors.sh             # Shared color utilities
└── docs/                     # Documentation
    ├── Ubuntu.md             # Ubuntu/WSL2 guide
    └── MacOS.md              # macOS guide
```

## 🛠️ Customization

Both Ubuntu and macOS setups are fully customizable:

1. **Modify shared Zsh config** - Edit `shared/zsh-config.sh` for common aliases and functions
2. **Modify OS-specific config** - Edit `scripts/ubuntu/zsh-config.sh` or `scripts/macOS/zsh-config.sh` for OS-specific settings
3. **Add new scripts** - Create scripts in `installations/` folder
4. **Adjust settings** - Modify individual installation scripts

See platform-specific documentation for details:

- [Ubuntu Customization Guide](docs/Ubuntu.md#%EF%B8%8F-customization)
- [macOS Customization Guide](docs/MacOS.md#%EF%B8%8F-customization)

## 🐛 Troubleshooting

For platform-specific troubleshooting:

- [Ubuntu/WSL2 Troubleshooting](docs/Ubuntu.md#-troubleshooting)
- [macOS Troubleshooting](docs/MacOS.md#-troubleshooting)

## 📄 License

MIT License - feel free to use and modify as needed.

## 🤝 Contributing

Feel free to submit issues or pull requests for improvements!
