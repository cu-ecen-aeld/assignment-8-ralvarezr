##############################################################
#
# LDD
#
##############################################################

LDD_VERSION = 'e8a0267425de287c94513ab7e77b6a9345d882b2'
# Note: Be sure to reference the *ssh* repository URL here (not https) to work properly
# with ssh keys and the automated build/test system.
LDD_SITE = 'git@github.com:cu-ecen-aeld/assignment-7-ralvarezr.git'
LDD_SITE_METHOD = git
LDD_GIT_SUBMODULES = YES

LDD_MODULE_SUBDIRS = misc-modules scull


$(eval $(kernel-module))
$(eval $(generic-package))