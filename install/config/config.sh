# Copy over Omarchy configs
mkdir -p ~/.config
cp -R ~/.local/share/omarchy/config/* ~/.config/

# Handle shell configuration safely
if [[ -z ${OMARCHY_LAYERED_INSTALL:-} ]]; then
  # Full install: Replace bashrc
  cp ~/.local/share/omarchy/default/bashrc ~/.bashrc
else
  # Layered install: Append source line if not present
  if ! grep -q "source ~/.local/share/omarchy/default/bashrc" ~/.bashrc; then
      echo -e "\n# Omarchy Shell Configuration" >> ~/.bashrc
      echo "[ -f ~/.local/share/omarchy/default/bashrc ] && source ~/.local/share/omarchy/default/bashrc" >> ~/.bashrc
      echo "Added Omarchy source to ~/.bashrc"
  else
      echo "Omarchy already sourced in ~/.bashrc"
  fi
fi
