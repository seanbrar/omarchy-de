if [[ -n ${OMARCHY_ONLINE_INSTALL:-} ]]; then
  # Install build tools
  sudo pacman -S --needed --noconfirm base-devel

  # Configure pacman
  if [[ -n ${OMARCHY_LAYERED_INSTALL:-} ]]; then
    if ! grep -q "\[omarchy\]" /etc/pacman.conf; then
      echo "Adding the Omarchy repository allows you to receive updates for Omarchy-specific packages."
      if gum confirm --default=yes "Add the Omarchy repository to pacman.conf? (recommended for updates)"; then
        echo -e "\n[omarchy]\nSigLevel = Required DatabaseOptional\nServer = https://pkgs.omarchy.org/stable/\$arch" | sudo tee -a /etc/pacman.conf >/dev/null
      else
        echo "Skipping Omarchy repository addition. You may need to manually install packages."
      fi
    fi
  else
    sudo cp -f ~/.local/share/omarchy/default/pacman/pacman.conf /etc/pacman.conf
    sudo cp -f ~/.local/share/omarchy/default/pacman/mirrorlist /etc/pacman.d/mirrorlist
  fi

  sudo pacman-key --recv-keys 40DFB630FF42BCFFB047046CF0134EE680CAC571 --keyserver keys.openpgp.org
  sudo pacman-key --lsign-key 40DFB630FF42BCFFB047046CF0134EE680CAC571

  sudo pacman -Sy
  sudo pacman -S --noconfirm --needed omarchy-keyring

  # Refresh all repos
  if [[ -n ${OMARCHY_LAYERED_INSTALL:-} ]]; then
    echo -e "\n\e[33mWarning: Installing packages on an out-of-date system can break your install.\e[0m"
    echo "It is strongly recommended to update your system before proceeding."
    if gum confirm --default=yes "Update system now (pacman -Syu)?"; then
       sudo pacman -Syu --noconfirm
    else
       echo "Skipping system update. You proceed at your own risk."
    fi
  else
    sudo pacman -Syu --noconfirm
  fi
fi
