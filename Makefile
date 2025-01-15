########################################################################
#
# Generic Makefile
#
# Time-stamp: <Sunday 2025-01-12 10:12:39 +1100 Graham Williams>
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
VER = $(shell egrep '^version:' pubspec.yaml | cut -d' ' -f2 | cut -d'+' -f1)
DATE=$(shell date +%Y-%m-%d)

# Identify a destination used by install.mk

DEST=/var/www/html/$(APP)

# The host for the repository of packages.

REPO=togaware.com
RLOC=apps/access

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
INC_MLHUB=skip
INC_WEBCAM=skip

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

  ginstall	After a github build download bundles and upload to togaware.com

  rtest       	Run the R script tests.

endef
export HELP

help::
	@echo "$$HELP"

########################################################################
# LOCAL TARGETS

locals:
	@echo "This might be the instructions to install $(APP)"

.PHONY: rtests
rtests:
	@bash r_test/rpart_test.sh

# realclean::
# 	snapcraft clean rattle

.PHONY: snap
snap:
	flutter clean
	snapcraft clean rattle
	perl -pi -e 's|version: .*|version: $(VER)|' snap/snapcraft.yaml
	snapcraft
	scp rattle_$(VER)_amd64.snap togaware.com:apps/access/rattle_dev_amd64.snap

.PHONY: isnap
isnap:
	snap install --dangerous rattle_0.0.1_amd64.snap

rattle.zip:
	rm -f rattle.zip
	flutter build linux
	rsync -avzh build/linux/x64/release/bundle/ rattle/
	zip -r rattle.zip rattle
	rm -rf rattle

OS := $(shell uname -s | tr '[:upper:]' '[:lower:]')

# Make apk on this machine to deal with signing. Then a ginstall of
# the built bundles from github, installed to solidcommunity.au and
# moved into ARCHIVE.

apk::
	rsync -avzh installers/$(APP).apk $(REPO):$(RLOC)
	ssh $(REPO) chmod a+r $(RLOC)/$(APP).apk
	mv -f installers/$(APP)-*.apk installers/ARCHIVE
	rm -f installers/$(APP).apk

# 20250110 gjw A ginstall of the github built bundles, and the locally
# built apk installed to the repository and moved into ARCHIVE.

ginstall: apk
	(cd installers; make $@)
