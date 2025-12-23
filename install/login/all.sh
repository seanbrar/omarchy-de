if [[ -z ${OMARCHY_LAYERED_INSTALL:-} ]]; then
  run_logged $OMARCHY_INSTALL/login/plymouth.sh
fi

run_logged $OMARCHY_INSTALL/login/default-keyring.sh

# sddm.sh handles layered mode prompting internally
run_logged $OMARCHY_INSTALL/login/sddm.sh

if [[ -z ${OMARCHY_LAYERED_INSTALL:-} ]]; then
  run_logged $OMARCHY_INSTALL/login/limine-snapper.sh
fi
