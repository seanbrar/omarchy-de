sudo mkdir -p /etc/sddm.conf.d

setup_sddm=true
if [[ -n ${OMARCHY_LAYERED_INSTALL:-} ]]; then
  if systemctl is-enabled display-manager.service &>/dev/null; then
    current_dm=$(systemctl status display-manager.service | grep -oP '(?<=/)[^/]+(?=\.service)' | head -1 || echo "unknown")
    echo -e "\nOmarchy prefers SDDM for the best experience (e.g., themed login screen)."
    echo "Your current display manager is: $current_dm"
    if ! gum confirm "Would you like to switch to SDDM? (Recommended for full Omarchy look)"; then
      setup_sddm=false
      echo "Keeping your current display manager."
    fi
  else
    if ! gum confirm "No active display manager found. Would you like to install and enable SDDM?"; then
      setup_sddm=false
    fi
  fi
fi

if [[ "$setup_sddm" == "true" ]]; then
  # Install SDDM if not present (filtered from base packages in layered mode)
  if ! pacman -Qi sddm &>/dev/null; then
      echo "Installing SDDM..."
      sudo pacman -S --noconfirm --needed sddm
  fi

  if [ ! -f /etc/sddm.conf.d/autologin.conf ]; then
    # In layered mode, default autologin to No (safer for existing multi-user systems)
    if [[ -z ${OMARCHY_LAYERED_INSTALL:-} ]] || gum confirm --default=no "Enable autologin for $USER? (No recommended for multi-user systems)"; then
      cat <<EOF | sudo tee /etc/sddm.conf.d/autologin.conf
[Autologin]
User=$USER
Session=hyprland-uwsm

[Theme]
Current=breeze
EOF
    fi
  fi

  # Don't use chrootable here as --now will cause issues for manual installs
  # Disable existing DM if we found one and are in layered mode
  if [[ -n ${OMARCHY_LAYERED_INSTALL:-} ]] && [[ "$current_dm" != "unknown" ]] && [[ -n "$current_dm" ]]; then
      echo "Disabling $current_dm..."
      sudo systemctl disable "$current_dm" 2>/dev/null || true
  fi

  sudo systemctl enable sddm.service
fi
