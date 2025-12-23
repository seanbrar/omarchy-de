# Install all base packages
mapfile -t packages < <(grep -v '^#' "$OMARCHY_INSTALL/omarchy-base.packages" | grep -v '^$')

if [[ -n ${OMARCHY_LAYERED_INSTALL:-} ]]; then
  # List of optional heavy/desktop-environment packages to filter out by default
  # We will offer these as opt-ins
  heavy_packages=(
    "libreoffice-fresh"
    "docker" "docker-buildx" "docker-compose" "lazydocker"
    "obs-studio" "kdenlive" "pinta" "gimp"
    "spotify"
  )

  # List of system-level packages that might conflict or be unwanted in an existing install
  system_packages=(
    "plymouth"
    "ufw" "ufw-docker"
    "cups" "cups-browsed" "cups-filters" "cups-pdf" "system-config-printer"
    "sddm"
    "avahi" "nss-mdns"
    "flatpak" # often already installed or managed differently
  )

  # Filter out heavy and system packages from the main list
  filtered_packages=()
  for pkg in "${packages[@]}"; do
    skip=false
    for heavy in "${heavy_packages[@]}"; do
      if [[ "$pkg" == "$heavy" ]]; then
        skip=true
        break
      fi
    done
    if [[ "$skip" == "false" ]]; then
      for sys in "${system_packages[@]}"; do
        if [[ "$pkg" == "$sys" ]]; then
          skip=true
          break
        fi
      done
    fi

    if [[ "$skip" == "false" ]]; then
      filtered_packages+=("$pkg")
    fi
  done
  packages=("${filtered_packages[@]}")

  # Install base packages
  echo "Installing base packages..."
  sudo pacman -S --noconfirm --needed "${packages[@]}"

  echo -e "\n--- Optional System Services ---"
  
  if gum confirm --default=yes "Install Printing Support (CUPS)?"; then
    sudo pacman -S --noconfirm --needed cups cups-browsed cups-filters cups-pdf system-config-printer ghostscript
  fi

  if gum confirm --default=no "Install Firewall (UFW)?"; then
    sudo pacman -S --noconfirm --needed ufw ufw-docker
  fi
  
  if gum confirm --default=no "Install Boot Splash (Plymouth)? (Note: Requires manual bootloader config)"; then
     sudo pacman -S --noconfirm --needed plymouth
  fi

  if gum confirm --default=yes "Install Avahi (Network Discovery)?"; then
     sudo pacman -S --noconfirm --needed avahi nss-mdns
  fi

  echo -e "\n--- Optional Application Suites ---"

  if gum confirm --default=yes "Install Office Suite (LibreOffice)?"; then
    sudo pacman -S --noconfirm --needed libreoffice-fresh
  fi

  if gum confirm --default=no "Install Docker tools (docker, lazy, compose)?"; then
    sudo pacman -S --noconfirm --needed docker docker-buildx docker-compose lazydocker
  fi

  if gum confirm --default=no "Install Creative Suite (OBS, Kdenlive, Pinta)?"; then
     # Only install what's in the base list (avoids error if we removed one from base list later)
     sudo pacman -S --noconfirm --needed obs-studio kdenlive pinta
  fi
  
  if gum confirm --default=yes "Install Spotify?"; then
     sudo pacman -S --noconfirm --needed spotify
  fi
  
  if gum confirm --default=yes "Install Flatpak support?"; then
      sudo pacman -S --noconfirm --needed flatpak
  fi

else
  # Standard install - everything
  sudo pacman -S --noconfirm --needed "${packages[@]}"
fi
