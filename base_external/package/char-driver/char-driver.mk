##############################################################
#
# Char Driver
#
##############################################################

CHAR_DRIVER_VERSION = '845bdcd11c33a0a00e736c8b7e593c0c7fb49f9e'
# Note: Be sure to reference the *ssh* repository URL here (not https) to work properly
# with ssh keys and the automated build/test system.
CHAR_DRIVER_SITE = 'git@github.com:cu-ecen-aeld/assignments-3-and-later-ralvarezr.git'
CHAR_DRIVER_SITE_METHOD = git
CHAR_DRIVER_GIT_SUBMODULES = YES

CHAR_DRIVER_MODULE_SUBDIRS = aesd-char-driver


$(eval $(kernel-module))
$(eval $(generic-package))

# define CHAR_DRIVER_INSTALL_TARGET_CMDS
# 	# load/unload script:
# 	$(INSTALL) -m 0700 \
# 		$(@D)/aesd-char-driver/aesdchar_load \
# 		$(@D)/aesd-char-driver/aesdchar_unload \
# 		$(TARGET_DIR)/usr/bin
# 	# init script
# # 	$(INSTALL) -d $(TARGET_DIR)/etc/init.d/
# # 	$(INSTALL) -m 0700 \
# # 		$(@D)/aesd-char-driver/aesdchar-start-stop \
# # 		$(TARGET_DIR)/etc/init.d/S97aesdchar
# endef