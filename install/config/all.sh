# =============================================================================
# Tier 1: Userland-safe (always run)
# These only touch ~/.config, ~/.local, or user-space settings
# =============================================================================
run_logged $OMARCHY_INSTALL/config/config.sh
run_logged $OMARCHY_INSTALL/config/theme.sh
run_logged $OMARCHY_INSTALL/config/branding.sh
run_logged $OMARCHY_INSTALL/config/git.sh
run_logged $OMARCHY_INSTALL/config/gpg.sh
run_logged $OMARCHY_INSTALL/config/xcompose.sh
run_logged $OMARCHY_INSTALL/config/mimetypes.sh
run_logged $OMARCHY_INSTALL/config/mise-work.sh
run_logged $OMARCHY_INSTALL/config/walker-elephant.sh
run_logged $OMARCHY_INSTALL/config/localdb.sh
run_logged $OMARCHY_INSTALL/config/detect-keyboard-layout.sh

# =============================================================================
# Tier 2: System-touching but low-risk (prompt in layered mode)
# These write to /etc or enable services but are generally non-destructive
# =============================================================================
if [[ -z ${OMARCHY_LAYERED_INSTALL:-} ]]; then
  # Full install: run all Tier 2 without prompts
  run_logged $OMARCHY_INSTALL/config/timezones.sh
  run_logged $OMARCHY_INSTALL/config/ssh-flakiness.sh
  run_logged $OMARCHY_INSTALL/config/fix-powerprofilesctl-shebang.sh
  run_logged $OMARCHY_INSTALL/config/hardware/bluetooth.sh
  run_logged $OMARCHY_INSTALL/config/hardware/printer.sh
  run_logged $OMARCHY_INSTALL/config/hardware/set-wireless-regdom.sh
  run_logged $OMARCHY_INSTALL/config/hardware/usb-autosuspend.sh
  run_logged $OMARCHY_INSTALL/config/hardware/fix-fkeys.sh
else
  # Layered install: prompt for each category
  echo -e "\n--- Optional system configurations ---"

  if gum confirm --default=no "Configure timezone settings? (skip if already set)"; then
    run_logged $OMARCHY_INSTALL/config/timezones.sh
  fi

  if gum confirm --default=yes "Apply SSH connection stability tweaks?"; then
    run_logged $OMARCHY_INSTALL/config/ssh-flakiness.sh
  fi

  if gum confirm --default=yes "Fix powerprofilesctl shebang (if installed)?"; then
    run_logged $OMARCHY_INSTALL/config/fix-powerprofilesctl-shebang.sh
  fi

  if gum confirm --default=yes "Enable Bluetooth service? (recommended)"; then
    run_logged $OMARCHY_INSTALL/config/hardware/bluetooth.sh
  fi

  if gum confirm --default=yes "Configure printer support (CUPS, Avahi)?"; then
    run_logged $OMARCHY_INSTALL/config/hardware/printer.sh
  fi

  if gum confirm --default=no "Set wireless regulatory domain based on timezone?"; then
    run_logged $OMARCHY_INSTALL/config/hardware/set-wireless-regdom.sh
  fi

  if gum confirm --default=no "Disable USB autosuspend (prevents peripheral disconnection)?"; then
    run_logged $OMARCHY_INSTALL/config/hardware/usb-autosuspend.sh
  fi

  if gum confirm --default=no "Configure function key behavior?"; then
    run_logged $OMARCHY_INSTALL/config/hardware/fix-fkeys.sh
  fi
fi

# =============================================================================
# Tier 3: Policy/security changes (skip in layered mode, with opt-in for some)
# These modify sudoers, PAM, or make significant system policy changes
# =============================================================================
if [[ -z ${OMARCHY_LAYERED_INSTALL:-} ]]; then
  # Security/sudo policy
  run_logged $OMARCHY_INSTALL/config/increase-sudo-tries.sh
  run_logged $OMARCHY_INSTALL/config/increase-lockout-limit.sh
  run_logged $OMARCHY_INSTALL/config/sudoless-asdcontrol.sh

  # System services and policy
  run_logged $OMARCHY_INSTALL/config/docker.sh
  run_logged $OMARCHY_INSTALL/config/hardware/network.sh
  run_logged $OMARCHY_INSTALL/config/fast-shutdown.sh
  run_logged $OMARCHY_INSTALL/config/hardware/ignore-power-button.sh

  # Hardware-specific kernel/initramfs modifications
  run_logged $OMARCHY_INSTALL/config/hardware/nvidia.sh
  run_logged $OMARCHY_INSTALL/config/hardware/fix-f13-amd-audio-input.sh
  run_logged $OMARCHY_INSTALL/config/hardware/fix-bcm43xx.sh
  run_logged $OMARCHY_INSTALL/config/hardware/fix-apple-spi-keyboard.sh
  run_logged $OMARCHY_INSTALL/config/hardware/fix-apple-suspend-nvme.sh
  run_logged $OMARCHY_INSTALL/config/hardware/fix-apple-t2.sh
  run_logged $OMARCHY_INSTALL/config/hardware/fix-surface-keyboard.sh
else
  # Layered mode: offer opt-in for commonly useful Tier 3 items
  echo -e "\n--- Optional system features ---"

  if gum confirm --default=no "Configure Docker? (adds user to docker group)"; then
    run_logged $OMARCHY_INSTALL/config/docker.sh
  fi

  if lspci | grep -qi nvidia; then
    if gum confirm --default=yes "NVIDIA GPU detected. Configure NVIDIA drivers?"; then
      run_logged $OMARCHY_INSTALL/config/hardware/nvidia.sh
    fi
  fi

  if gum confirm --default=no "Enable fast shutdown? (reduces systemd timeout to 10s)"; then
    run_logged $OMARCHY_INSTALL/config/fast-shutdown.sh
  fi

  # Note: Security-sensitive items (sudoers, PAM) remain skipped in layered mode
fi

