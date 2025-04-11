########################################################################
#
# Generic Makefile
#
# Time-stamp: <Saturday 2025-04-12 09:55:33 +1000 Graham Williams>
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

# The host for the repository of packages, the path on the server to
# the download folder, and the URL to the downloads.

REPO=togaware.com
RLOC=apps/access
DWLD=https://$(REPO)/installers

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

  ginstall	After a github build download bundles and upload to $(REPO)

  rtest       	Run the R script tests.

endef
export HELP

help::
	@echo "$$HELP"

########################################################################
# LOCAL TARGETS

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

deb:
	(cd installers; make $@)
	rsync -avzh installers/rattle_$(VER)_amd64.deb $(REPO):$(RLOC)/rattle_amd64.deb
	ssh $(REPO) chmod a+r $(RLOC)/rattle_amd64.deb
	wget https://access.togaware.com/rattle_amd64.deb -O rattle_amd64.deb
	wajig install rattle_amd64.deb
	rm -f rattle_amd64.deb
	mv -f installers/rattle_*.deb installers/ARCHIVE


# A ginstall will install the github built bundles, and the locally
# built apk installed to the repository and moved into ARCHIVE. (gjw
# 20250110)
#
# The deb build for a while was placing the data and lib folders into
# /ust/bin/ which when we try to add another package (healthpod) also
# tries to do the same and so conflicts. This was subsequently
# fixed. (gjw 20250218)
#
# Solved the issue by putting the package files into /usr/lib/rattle
# and then symlinked the executable to /usr/bin/rattle. This is
# working so add deb into the install and now utilise that for the
# default install on my machine.  (gjw 20250222)
#
# Move the apk build to last as I am not usually waiting on it at
# present, while I am waiting on the deb install to deploy to teaching
# labs. (gjw 20250321)

ginstall: deb
	(cd installers; make $@)
	make apk
