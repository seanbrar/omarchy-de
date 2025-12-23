#!/bin/bash

# Omarchy Uninstall Script (Best-effort)
# This script attempts to remove the Omarchy layer from your system.

# Safety guard
if [ "$EUID" -eq 0 ]; then
  echo "Please run as a normal user (not root)."
  exit 1
fi

echo "Welcome to the Omarchy uninstaller."
echo "This script will attempt to revert system changes made by Omarchy."
echo

# 1. Repository Removal
if grep -q "\[omarchy\]" /etc/pacman.conf; then
  echo "-> Removing Omarchy repository from /etc/pacman.conf..."
  # Removes the section starting with [omarchy] until the next blank line
  sudo sed -i '/^\[omarchy\]/,/^$/d' /etc/pacman.conf
fi

# 2. Keyring Removal
if pacman -Qi omarchy-keyring &>/dev/null; then
  echo "-> Removing Omarchy keyring package..."
  sudo pacman -Rs --noconfirm omarchy-keyring
fi

echo "-> Note: Omarchy's signing key may still be in your pacman-key database."
echo "   If you wish to remove it, run: sudo pacman-key --delete 40DFB630FF42BCFFB047046CF0134EE680CAC571"

# 3. Sudoers Cleanup
echo "-> Checking for Omarchy sudoers files..."
for f in first-run passwd-tries asdcontrol-nopasswd allow-reboot; do
  if [ -f "/etc/sudoers.d/$f" ]; then
    echo "   Removing /etc/sudoers.d/$f"
    sudo rm -f "/etc/sudoers.d/$f"
  fi
done

# 4. SDDM / Autologin
if [ -f /etc/sddm.conf.d/autologin.conf ]; then
  echo "-> Removing SDDM autologin configuration..."
  sudo rm -f /etc/sddm.conf.d/autologin.conf
fi

# 5. Config Cleanup
echo "-> Cleaning up configuration files..."
if [ -d "$HOME/.config" ]; then
  read -p "Would you like to move Omarchy-created .config entries to a backup? (y/N) " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    BACKUP_DIR="$HOME/.config.omarchy.bak.$(date +%s)"
    mkdir -p "$BACKUP_DIR"
    echo "   Moving .config files to $BACKUP_DIR..."
    # List of main folders Omarchy touches based on research
    for d in hypr walker waybar swayosd alacritty mako ghostty omarchy; do
      if [ -d "$HOME/.config/$d" ]; then
        mv "$HOME/.config/$d" "$BACKUP_DIR/"
      fi
    done
    [ -f "$HOME/.bashrc" ] && cp "$HOME/.bashrc" "$BACKUP_DIR/bashrc" && echo "   Backed up .bashrc"
  fi
fi

# Remove Omarchy source from .bashrc
if [ -f "$HOME/.bashrc" ]; then
  if grep -q "omarchy/default/bashrc" "$HOME/.bashrc"; then
    echo "-> Removing Omarchy source line from ~/.bashrc..."
    # Remove the comment and the source line
    sed -i '/# Omarchy Shell Configuration/d' "$HOME/.bashrc"
    sed -i '/source ~\/.*omarchy\/default\/bashrc/d' "$HOME/.bashrc"
  fi
fi

# 6. Package Removal (Optional)
echo "-> Package removal..."
read -p "Would you like to see a list of base packages Omarchy installed? (y/N) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  echo "Packages installed by Omarchy include: hyprland, waybar, walker-bin, etc."
  echo "To remove them, you can run: sudo pacman -Rs <package_name>"
  echo "Note: Be careful not to remove packages you need for other purposes!"
fi

# 7. Layered Mode Marker
if [ -f "$HOME/.config/omarchy/.layered" ]; then
  echo "-> Removing layered mode marker..."
  rm -f "$HOME/.config/omarchy/.layered"
fi

# 8. Local Files
if [ -d "$HOME/.local/share/omarchy" ]; then
  echo "-> Removing Omarchy source files from ~/.local/share/omarchy..."
  rm -rf "$HOME/.local/share/omarchy"
fi

echo
echo "Best-effort uninstallation complete."
echo "Please check /etc/pacman.conf and your home directory to ensure everything is as you expect."
echo "A reboot is recommended to clear any remaining service states."
