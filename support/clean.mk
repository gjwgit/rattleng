########################################################################
#
# Makefile template for Cleaning
#
# Copyright 2018-2019 (c) Graham.Williams@togaware.com
#
# License: Creative Commons Attribution-ShareAlike 4.0 International.
#
########################################################################

define CLEAN_HELP
Cleanup:

  clean
  realclean

endef
export CLEAN_HELP

help::
	@echo "$$CLEAN_HELP"

.PHONY: clean
clean::

.PHONY: realclean
realclean::
	find . -type f \( -name "*~" -o -name "*.bak" \) -exec rm {} \;

