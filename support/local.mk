########################################################################
#
# Makefile template for Local rules
#
# Copyright 2021-2025 (c) Graham.Williams@togaware.com
#
# License: Creative Commons Attribution-ShareAlike 4.0 International.
#
########################################################################

define LOCAL_HELP
local:


  rtest     Run the R script tests.

endef
export FLUTTER_HELP

help::
	@echo "$$FLUTTER_HELP"

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
