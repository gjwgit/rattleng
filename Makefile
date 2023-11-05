########################################################################
#
# Generic Makefile
#
# Time-stamp: <Sunday 2023-11-05 20:06:50 +1100 Graham Williams>
#
# Copyright (c) Graham.Williams@togaware.com
#
# License: Creative Commons Attribution-ShareAlike 4.0 International.
#
########################################################################

# App is often the current directory name.
#
# App version numbers
#   Major release
#   Minor update
#   Trivial update or bug fix

APP=$(shell pwd | xargs basename)
VER=0.0.1
DATE=$(shell date +%Y-%m-%d)

########################################################################
# Supported Makefile modules.

# Often the support Makefiles will be in the local support folder, or
# else installed in the local user's shares.

INC_BASE=$(HOME)/.local/share/make
INC_BASE=support


# Specific Makefiles will be loaded if they are found in
# INC_BASE. Sometimes the INC_BASE is shared by multiple local
# Makefiles and we want to skip specific makes. Simply define the
# appropriate INC to a non-existant location and it will be skipped.

INC_DOCKER=skip

# Load any modules available.

INC_MODULE=$(INC_BASE)/modules.mk

ifneq ("$(wildcard $(INC_MODULE))","")
  include $(INC_MODULE)
endif

########################################################################
# HELP
#
# Help for targets defined in this Makefile.

define HELP
$(APP):

  docs         Generate doc and install to ecosysl.
  bmacos       Build macos binary

  rtest       Run the R script tests.
endef
export HELP

help::
	@echo "$$HELP"

########################################################################
# LOCAL TARGETS

locals:
	@echo "This might be the instructions to install $(APP)"

bmacos:
	flutter build macos
	zip bstim_$(VER).zip build/macos/Build/Products/Release/bstim_$(VER).app

docs::
	rsync -avzh doc/api/ root@ecosysl.net:/var/www/html/rattleng/

.PHONY: rtests
rtests:
	@bash r_test/rpart_test.sh

.PHONY: prep
prep: rtests checks tests docs

realclean::
	snapcraft clean rattle

.PHONY: snap
snap:
	flutter clean
	snapcraft clean rattle
	snapcraft

.PHONY: isnap
isnap:
	snap install --dangerous rattle_0.0.1_amd64.snap 

rattle.zip:
	rm -f rattle.zip
	flutter build linux
	rsync -avzh build/linux/x64/release/bundle/ rattle/
	zip -r rattle.zip rattle
	rm -rf rattle

%.itest:
	flutter test --device-id linux --dart-define=PAUSE=0 integration_test/$*_test.dart
