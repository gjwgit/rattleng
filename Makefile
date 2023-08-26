########################################################################
#
# Generic Makefile
#
# Time-stamp: <Saturday 2023-08-26 11:18:52 +1000 Graham Williams>
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

  docs		Generate doc and install to ecosysl.
  test		Run the integration test suite.
  ignore	Look for usage of ignore: directives.

  r_test       Run the R script tests.

endef
export HELP

help::
	@echo "$$HELP"

########################################################################
# LOCAL TARGETS

locals:
	@echo "This might be the instructions to install $(APP)"

docs: doc
	chmod -R go+rX doc
	rsync -avzh doc/api/ root@ecosysl.net:/var/www/html/bstim/

.PHONY: ignore
ignore:
	@rgrep -C 2 ignore: lib

.PHONY: r_test
r_test:
	@bash r_tests/rpart_test.sh
