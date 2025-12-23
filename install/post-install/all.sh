run_logged $OMARCHY_INSTALL/post-install/pacman.sh

# Skip passwordless reboot in layered mode (installer convenience, not DE feature)
if [[ -z ${OMARCHY_LAYERED_INSTALL:-} ]]; then
  source $OMARCHY_INSTALL/post-install/allow-reboot.sh
fi

source $OMARCHY_INSTALL/post-install/restore-hooks.sh
source $OMARCHY_INSTALL/post-install/finished.sh
