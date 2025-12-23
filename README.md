# Omarchy-DE

**A Desktop Environment layer based on [Omarchy](https://github.com/basecamp/omarchy) for existing Arch Linux systems.**

> [!NOTE]
> This is **not** official Omarchy. This is a fork that adapts Omarchy to work as a DE layer rather than a full meta-distro. Please report issues to this repo, not upstream.

## What is this?

[Omarchy](https://omarchy.org) is a beautiful, modern & opinionated Linux distribution by DHH. It normally requires:
- Fresh Arch Linux install from their ISO
- Limine bootloader
- Btrfs filesystem

**Omarchy-DE** removes these requirements, letting you install the Omarchy desktop experience on your existing Arch system while respecting your current setup.

## Prerequisites

- Arch Linux (vanilla, not derivatives like Manjaro/EndeavourOS)
- x86_64 architecture
- Secure Boot disabled
- Not running as root
- **System updated** (`sudo pacman -Syu` before starting)

## Installation

```bash
git clone https://github.com/seanbrar/omarchy-de.git
cd omarchy-de
./layered-install.sh
```

### What to Expect

The installer runs in **tiered mode** to respect your existing system:

| Tier | What Happens | Examples |
|------|--------------|----------|
| **Always** | Userland configs installed without prompts | Themes, keybindings, dotfiles |
| **Prompted (default yes)** | Core Omarchy experience, low-risk | Bluetooth, Printing, SSH tweaks, LibreOffice, Flatpak |
| **Prompted (default no)** | Optional or hardware-specific | Docker, Firewall, Plymouth, Creative Suite |
| **Skipped** | Policy/security changes not applied | Sudoers tweaks, PAM changes |

You'll also be asked about:
- **System Update**: Whether to run `pacman -Syu` before installing (recommended)
- **Repository**: Whether to add the `[omarchy]` repo (recommended for updates)
- **Display Manager**: Whether to switch to SDDM or keep yours

## What Gets Installed

- **Window Manager**: Hyprland (Wayland compositor)
- **Status Bar**: Waybar
- **Launcher**: Walker
- **Terminal**: Alacritty, Ghostty
- **File Manager**: Nautilus
- **Browser**: Chromium
- **Editor**: Neovim
- Plus themes, fonts, and Omarchy's user configuration

## Differences from Upstream Omarchy

> [!IMPORTANT]
> This is the Omarchy *aesthetic* and *UX*, not the full Omarchy *system*.

| Aspect | Upstream Omarchy | Omarchy-DE |
|--------|------------------|------------|
| Target | Fresh Arch ISO | Existing Arch system |
| Bootloader | Requires Limine | Keeps yours |
| Filesystem | Requires btrfs | Any filesystem |
| Pacman config | Replaces entirely | Appends repo (prompted, default yes) |
| Boot splash | Installs Plymouth | Prompts (default no) |
| Printing (CUPS) | Installed | Prompts (default yes) |
| Firewall (UFW) | Installed | Prompts (default no) |
| Display manager | Auto-enables SDDM | Prompts (no default, preserves yours) |
| Sudo/PAM policy | Modified | **Not touched** |
| Docker setup | Configured | Prompts (default no) |
| Hardware fixes | Applied unconditionally | NVIDIA prompted when detected; others **skipped** |

### What Won't Work

| Feature | Reason |
|---------|--------|
| Btrfs snapshots/rollback | Requires btrfs filesystem |
| Boot menu entries | Requires Limine bootloader |
| Snapshot-aware boot | Requires Limine + btrfs |

> [!TIP]
> Upstream migrations that reference missing commands (like Limine) will fail gracefully—you can skip them when prompted.

## Uninstall

```bash
./uninstall.sh
```

This performs a best-effort cleanup:
- Removes Omarchy repository from pacman.conf
- Removes Omarchy keyring
- Cleans up sudoers files (if any were manually added)
- Optionally backs up config files
- Removes `~/.local/share/omarchy`

Packages installed by Omarchy are **not** automatically removed to avoid breaking dependencies.

## Staying Updated

Use **Update → Omarchy** from the Omarchy menu (`Super + Alt + Space`). This pulls the latest code, runs any pending migrations, and updates all system packages.

When new releases are available, a circle arrow icon appears next to your clock—click it to start the update.

> [!NOTE]
> Avoid running `pacman -Syu` directly, as you may miss configuration updates needed for newer package versions.

> [!NOTE]
> This fork is maintained to track upstream Omarchy features while keeping the DE layer compatible. **Do not** merge directly from `basecamp/omarchy`, as that will overwrite the layered installation logic and may break your system.

## License

Omarchy is released under the [MIT License](https://opensource.org/licenses/MIT).

---

Based on [Omarchy](https://omarchy.org) by [DHH](https://dhh.dk/) and [37signals](https://37signals.com).
