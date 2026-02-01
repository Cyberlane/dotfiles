# 💻 Justin's Dotfiles

This is my personal command center. It’s a highly automated, secure environment for macOS, managed by [chezmoi](https://www.chezmoi.io/) and powered by [1Password](https://1password.com/).

## 🛠 The Stack

* **Shell:** `zsh` managed via **Antidote** (plugin manager).
* **Terminal:** **WezTerm** + **tmux** (using the Catppuccin Macchiato flavor).
* **Prompt:** **Starship** for a clean, informative status line.
* **Security:** **1Password SSH Agent** handles all my server auth and Git commit signing. No private keys ever touch the disk in plain text.
* **Keyboard:** **Karabiner-Elements** for custom key remapping.
* **Package Management:** **Homebrew** via a managed `Brewfile`.

---

## 🚀 Fresh Install (New Mac)

On a brand new machine, paste this into the default terminal:

### 1. The Prerequisites
Install Homebrew and the 1Password CLI first:
```zsh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/opt/homebrew/bin/brew shellenv)"
brew install 1password-cli chezmoi
```

### 2. The Big Bang
Once 1Password is installed, log in to the 1Password App and enable "CLI Integration" in Settings.
Then run this:
```zsh
chezmoi init --apply git@github.com:Cyberlane/dotfiles.git
```

### 3. Final Touches
Open up WezTerm, open up tmux, hit `Ctrl+b` to install the plugins.


### 4. Drink coffee and eat cake ☕️🍰
