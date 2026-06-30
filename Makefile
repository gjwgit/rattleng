########################################################################
#
# Generic Makefile
#
# Time-stamp: <Monday 2026-06-15 20:31:20 +1000 Graham Williams>
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

REPO=solidcommunity.au
RLOC=/var/www/html/web/installers/
DWLD=https://$(REPO)/installers/

########################################################################
# Supported Makefile modules.

# Often the support Makefiles will be in the local support folder, or
# else installed in the local user's shares.

INC_BASE=$(HOME)/.local/share/make
INC_BASE=support

# Specific Makefiles will be loaded if they are found in
# INC_BASE. Sometimes the INC_BASE is shared by multiple local
# Makefiles and we want to skip specific makes. Simply define the
# appropriate INC to a non-existent location and it will be skipped.

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

  ginstall   After a github build download bundles and upload to $(REPO)

  local	     Install to $(HOME)/.local/share/$(APP)
    tgz	     Upload the installer to $(REPO)
  apk	     Upload the installer to $(REPO)

endef
export HELP

help::
	@echo "$$HELP"

########################################################################
# LOCAL TARGETS

#
# Manage the production install on the remote server.
#

clean::
	rm -f README.html

# Linux: Install locally.

local: tgz
	tar zxvf installers/$(APP).tar.gz -C $(HOME)/.local/share/

# Linux: Upload the installers for general access from the repository.

tgz::
	chmod a+r installers/$(APP)*.tar.gz
	rsync -avzh installers/$(APP)*.tar.gz $(REPO):/var/www/html/installers/
	ssh $(REPO) chmod -R go+rX /var/www/html/installers/
	ssh $(REPO) chmod go=x /var/www/html/installers/

# Android: Upload to Solid Community installers for general access.

# Make apk on this machine to deal with signing. Then a ginstall of
# the built bundles from github, installed to solidcommunity.au and
# moved into ARCHIVE.

apk::
	rsync -avzh installers/$(APP).apk $(REPO):$(RLOC)
	ssh $(REPO) chmod a+r $(RLOC)$(APP).apk
	mv -f installers/$(APP)-*.apk installers/ARCHIVE/
	rm -f installers/$(APP).apk
	@echo ''

appbundle::
	rsync -avzh installers/$(APP).aab $(REPO):$(RLOC)
	ssh $(REPO) chmod a+r $(RLOC)$(APP).aab
	mv -f installers/$(APP)-*.aab installers/ARCHIVE/
	rm -f installers/$(APP).aab
	@echo ''

# 20251226 gjw This has been moved into the installers github workflow
# but is retained here for convenience to build a deb locally and
# install it, often for a quick testing cycle.

deb:
	@echo "Build $(APP) version $(VER)"
	(cd installers; make $@)
	rsync -avzh installers/$(APP)_$(VER)_amd64.deb $(REPO):$(RLOC)$(APP)_amd64.deb
	ssh $(REPO) chmod a+r $(RLOC)$(APP)_amd64.deb
	wget $(DWLD)$(APP)_amd64.deb -O $(APP)_amd64.deb
	wajig install $(APP)_amd64.deb
	rm -f $(APP)_amd64.deb
	mv -f installers/$(APP)_*.deb installers/ARCHIVE/

dinstall:
	wget $(DWLD)$(APP)_amd64.deb -O $(APP)_amd64.deb
	wajig install $(APP)_amd64.deb
	rm -f $(APP)_amd64.deb

sinstall:
	wget $(DWLD)$(APP)_amd64.snap -O $(APP)_amd64.snap
	sudo snap install --dangerous $(APP)_amd64.snap
	rm -f $(APP)_amd64.snap

# 20250110 gjw A ginstall of the github built bundles, and the locally
# built apk installed to the repository and moved into ARCHIVE.
#
# 20250218 gjw Remove the deb build for now as it is placing the data
# and lib folders into /ust/bin/ which when we try to add another
# package also tries to do that, which is how I found the issue.
#
# 20250222 gjw Solved the issue by putting the package files into
# /usr/lib/rattle and then symlinked the executable to
# /usr/bin/rattle. This is working so add deb into the install and now
# utilise that for the default install on my machine.

.PHONY: upload
upload:
	(cd installers; make ginstall)
	@echo ''

.PHONY: debin
debin:
	@echo '******************** LOCAL INSTALL DEB'
	wajig install installers/ARCHIVE/$(APP)_$(VER)_amd64.deb
	@echo ''

# 20260103 gjw Note that `debin` depends on the deb file being upladed
# to the ARCHIVE and so the `upload` target is a prerequisite. Put it
# at the end as it requires interaction (sudo password) and if earlier
# it will hold up the oher non-interactive builds.

.PHONY: ginstall
ginstall: upload prod apk appbundle

.PHONY: ginfo
ginfo:
	@bumpId=$$(gh run list --limit 100 --json databaseId,displayTitle,workflowName \
		| jq -r '.[] | select(.workflowName | startswith("Build Installers")) | select(.displayTitle | startswith("Bump version")) | .databaseId' \
		| head -n 1); \
	if [ -n "$$bumpId" ]; then \
		echo "Bump ID: $$bumpId"; \
		gh run view "$$bumpId"; \
		gh run view "$$bumpId" --json status,conclusion; \
	else \
		echo "No bump ID found."; \
	fi

ZFILES := lib test integration_test pubspec.yaml README.md CLAUDE.md

.PHONY: zip
zip:
	@mkdir -p ignore
	@rm -f ignore/$(APP)_lib.zip
	@to_zip=""
	@for f in $(ZFILES); do \
		if [ -e "$$f" ]; then \
			to_zip="$$to_zip $$f"; \
		fi; \
	done; \
	zip -r ignore/$(APP)_lib.zip $$to_zip
	open ignore/

.PHONY: claude
claude:
	bash support/meld_zip_from_claude.sh

.PHONY: bump
bump:
	@make prep
	@MESSAGE=$$(grep '^+.*\[' CHANGELOG.md | head -n 1 | sed 's/^+ //; s/ \[.*//'); \
	VERSION=$$(grep '^+.*\[' CHANGELOG.md | head -n 1 | sed 's/.*\[//; s/ .*//'); \
	if [ -z "$$MESSAGE" ]; then \
		echo "Error: Could not extract message from CHANGELOG.md"; \
		exit 1; \
	fi; \
	git commit -am "Bump version $$VERSION $$MESSAGE"; \
	git push
