#!/bin/bash

# Restore mkinitcpio hooks if they were disabled
# This must run at the end of installation to ensure kernel updates work in the future

if [ -f /usr/share/libalpm/hooks/90-mkinitcpio-install.hook.disabled ]; then
  echo "Restoring mkinitcpio install hook..."
  sudo mv /usr/share/libalpm/hooks/90-mkinitcpio-install.hook.disabled /usr/share/libalpm/hooks/90-mkinitcpio-install.hook
fi

if [ -f /usr/share/libalpm/hooks/60-mkinitcpio-remove.hook.disabled ]; then
  echo "Restoring mkinitcpio remove hook..."
  sudo mv /usr/share/libalpm/hooks/60-mkinitcpio-remove.hook.disabled /usr/share/libalpm/hooks/60-mkinitcpio-remove.hook
fi
