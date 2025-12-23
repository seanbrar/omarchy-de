# Configure pacman
if [[ -z ${OMARCHY_LAYERED_INSTALL:-} ]]; then
  sudo cp -f ~/.local/share/omarchy/default/pacman/pacman.conf /etc/pacman.conf
  sudo cp -f ~/.local/share/omarchy/default/pacman/mirrorlist-stable /etc/pacman.d/mirrorlist
fi

# Apple T2 Mac hardware support
if lspci -nn | grep -q "106b:180[12]"; then
  add_apple_repo=true
  if [[ -n ${OMARCHY_LAYERED_INSTALL:-} ]]; then
    echo -e "\n--- Apple T2 Mac detected ---"
    if ! gum confirm --default=yes "Add arch-mact2 repository for T2 hardware support?"; then
      add_apple_repo=false
    fi
  fi

  if [[ "$add_apple_repo" == "true" ]] && ! grep -q "\[arch-mact2\]" /etc/pacman.conf; then
    cat <<EOF | sudo tee -a /etc/pacman.conf >/dev/null

[arch-mact2]
Server = https://github.com/NoaHimesaka1873/arch-mact2-mirror/releases/download/release
SigLevel = Never
EOF
  fi
fi

