# 🎨 fastfetch-configs

A collection of custom, highly-polished, and aesthetic configurations for [fastfetch](https://github.com/fastfetch-cli/fastfetch).

---

## 🚀 Configurations

### 1. sgobex
A clean, modern layout with a striking blue/gray accent palette, custom icon-driven system modules, and a beautiful image logo.

- **Accent Color:** Blue/Gray (`\u001b[34m`)
- **Key Features:**
  - Custom title block & separator (``)
  - Personalized CPU & GPU descriptions
  - Dynamic package count tracker (pacman)
  - Beautiful status division lines (`◆ ─────────────────────── ◆`)
- **Logo:** `logo.png` (designed to render beautifully with Kitty/WezTerm image protocol)

### 2. minimal
A tiny, distraction-free layout — just the essentials with a small distro logo. No Nerd Font or image support needed, works in literally any terminal.

### 3. server
Plain-ASCII layout made for servers and SSH sessions: OS, kernel, uptime, IP, CPU, memory, swap, disk, and process count. Zero font or color requirements.

### 4. nordic
Cool Nord-inspired blues with a rounded box frame (`╭─╮ … ╰─╯`) around icon-driven modules.

- **Accent Colors:** Cyan & Blue
- **Requires:** Nerd Font

### 5. gruvbox
Warm retro yellows and oranges with lowercase text labels next to each icon, a chunky divider, and a color-circle strip.

- **Accent Colors:** Yellow & Red
- **Requires:** Nerd Font

### 6. catppuccin
Soft mauve & pink pastels straight out of the Catppuccin Mocha palette, with sparkly dividers.

- **Accent Colors:** Mauve (`#cba6f7`) & Pink (`#f5c2e1`) — true color
- **Requires:** Nerd Font, true-color terminal

### 7. tokyo-night
Neon purple & blue inspired by the Tokyo Night palette, with clock-icon dividers and a color-circle strip.

- **Accent Colors:** Purple (`#bb9af7`) & Blue (`#7aa2f7`) — true color
- **Requires:** Nerd Font, true-color terminal

### 8. matrix
All-green hacker terminal aesthetic — `>>` separators, gradient block dividers, process count and local IP included. The distro logo is recolored green too.

- **Accent Color:** Green
- **Requires:** Nerd Font

### 9. verbose
Everything fastfetch knows about your machine, grouped into **SYSTEM**, **DESKTOP**, and **HARDWARE** sections — including theme, icons, fonts, display, swap, disk, and battery.

- **Accent Color:** Magenta
- **Requires:** Nerd Font

---

## 📥 Installation & Usage

### Quick Install (recommended)
One command, no cloning needed — it fetches the repo, shows a picker, backs up your existing config, and installs the one you choose:
```bash
curl -fsSL https://raw.githubusercontent.com/iamanuclearwarhead/fastfetch-configs/main/install.sh | bash
```

Or from a local clone:
```bash
./install.sh              # interactive picker
./install.sh nordic       # install a config by name
./install.sh -l           # list available configs
./install.sh -p nordic    # preview a config without installing
```

Your existing `~/.config/fastfetch` is automatically backed up to a timestamped `fastfetch.bak.*` folder before anything is copied.

### Manual Install

To apply any of these configurations by hand instead, follow the steps below:

### Step 1: Backup Your Existing Config (Recommended)
Before copying anything, make sure you back up your existing fastfetch configuration:
```bash
mv ~/.config/fastfetch ~/.config/fastfetch.bak
```

### Step 2: Install a Configuration
Choose a configuration from this repository (e.g., `sgobex`) and copy it to your `~/.config/fastfetch` folder:

```bash
# Create the config folder if it doesn't exist
mkdir -p ~/.config/fastfetch

# Clone this repo (if you haven't already)
git clone https://github.com/iamanuclearwarhead/fastfetch-configs.git
cd fastfetch-configs

# Copy the config and its assets
cp -r sgobex/* ~/.config/fastfetch/
```

### Tip: Try Before You Install
You can preview any config straight from the cloned repo without touching your own setup:
```bash
fastfetch --config ./nordic/config.jsonc
```

### Step 3: Run Fastfetch
Run fastfetch to see your new configuration in action!
```bash
fastfetch
```

---

## 🎨 System Requirements

To ensure all icons and images render correctly:
1. **Nerd Font:** A Nerd Font must be active in your terminal emulator (e.g., *JetBrainsMono Nerd Font*, *FiraCode Nerd Font*) to render the status icons (` `, ` `, ` `, etc.).
2. **Image Support:** For the custom image logo to render, you need a terminal emulator that supports image protocols (e.g., **Kitty** with `type: "kitty"`, **WezTerm**, or **Foot** with proper configuration).

---

## 🤝 Contributing

Have a beautiful fastfetch config you'd like to share? Contributions are welcome!
1. Fork the repository.
2. Create a folder with your config's name (e.g., `my-cool-theme/`).
3. Place your `config.jsonc` and any required image/logo inside.
4. Add your config to the list in this `README.md`.
5. Open a Pull Request!
