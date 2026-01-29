# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Load NVM

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See <https://github.com/ohmyzsh/ohmyzsh/wiki/Themes>
ZSH_THEME="jonathan"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "jonathan" "fino" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git zsh-z zsh-autosuggestions zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases

# zsh
alias zshConfig="code ~/.zshrc"
alias zshRestart="source ~/.zshrc"
alias ohmyzsh="code ~/.oh-my-zsh"

function zshHistoryFix() {
    mv ~/.zsh_history ~/.zsh_history_bad
    strings ~/.zsh_history_bad >~/.zsh_history
    fc -R ~/.zsh_history
    rm ~/.zsh_history_bad
}

# Git
alias gc="git commit -m"
alias gpl="git pull"
alias gp="git push"
alias gfa="git fetch --all"
alias gck="git checkout"
alias gckb="git checkout -b"
alias sd="git fetch --all && git merge origin/develop"
alias signCommit="git config commit.gpgsign true"

function gacp() {
    git add .
    git commit -m "$1"
    git push
}

function gitToSaritasaProfile() {
    git config user.name "khoanguyen-saritasa"
    git config user.email "khoa.nguyen@saritasa.com"
    git config user.signingkey ~/.ssh/saritasa.pub
}

function gitToPersonalProfile() {
    git config user.name "khoanguyn1411"
    git config user.email "khoaah1411@gmail.com"
    git config user.signingkey ~/.ssh/personal.pub
}

function generateSshKey() {
    ssh-keygen -t ed25519 -C "$1" -f ~/.ssh/$2
}

function generatePersonalSshKey() {
    ssh-keygen -t ed25519 -C "khoaah1411@gmail.com" -f ~/.ssh/personal
}

# IDE
# WSL uses launcher scripts to open IDEs with remote connection
# Native Ubuntu uses direct commands
if grep -qi microsoft /proc/version 2>/dev/null || [ -n "$WSL_DISTRO_NAME" ]; then
  # WSL environment - use launcher scripts
  alias wf="source ~/windsurf-launcher.sh"
  alias ag="source ~/antigravity-launcher.sh"
else
  # Native Ubuntu - use direct commands
  alias wf="windsurf"
  alias ag="antigravity"
fi

# Node
alias ns="npm start"

# Python
alias av="source venv/bin/activate"
alias py="python3"

function pi() {
    pip install $1
    pip freeze > requirements.txt
}

function initPython() {
    python3 -m venv venv
    source venv/bin/activate

    if [ -f requirements.txt ]; then
        echo "📦 Installing dependencies from requirements.txt"
        pip install -r requirements.txt
    else
        echo "📄 requirements.txt not found, creating one"
        pip freeze > requirements.txt
        echo "✅ requirements.txt created"
    fi
}

# Docker
alias dockerCleanAll="docker system prune -a --volumes"