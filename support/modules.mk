########################################################################
# Supported Makefile modules.
#
# Often the support Makefiles will be in the local support folder, or
# else installed in the local user's shares.

INC_CLEAN    ?= $(INC_BASE)/clean.mk
INC_BOOKDOWN ?= $(INC_BASE)/bookdown.mk
INC_R        ?= $(INC_BASE)/r.mk
INC_KNITR    ?= $(INC_BASE)/knitr.mk
INC_PANDOC   ?= $(INC_BASE)/pandoc.mk
INC_GIT      ?= $(INC_BASE)/git.mk
INC_AZURE    ?= $(INC_BASE)/azure.mk
INC_LATEX    ?= $(INC_BASE)/latex.mk
INC_PDF      ?= $(INC_BASE)/pdf.mk
INC_DOCKER   ?= $(INC_BASE)/docker.mk
INC_FLUTTER  ?= $(INC_BASE)/flutter.mk
INC_JEKYLL   ?= $(INC_BASE)/jekyll.mk
INC_MLHUB    ?= $(INC_BASE)/mlhub.mk
INC_WEBCAM   ?= $(INC_BASE)/webcam.mk
INC_INSTALL  ?= $(INC_BASE)/install.mk

ifneq ("$(wildcard $(INC_CLEAN))","")
  include $(INC_CLEAN)
endif
ifneq ("$(wildcard $(INC_BOOKDOWN))","")
  include $(INC_BOOKDOWN)
endif
ifneq ("$(wildcard $(INC_R))","")
  include $(INC_R)
endif
ifneq ("$(wildcard $(INC_KNITR))","")
  include $(INC_KNITR)
endif
ifneq ("$(wildcard $(INC_PANDOC))","")
  include $(INC_PANDOC)
endif
ifneq ("$(wildcard $(INC_FLUTTER))","")
  include $(INC_FLUTTER)
endif
ifneq ("$(wildcard $(INC_GIT))","")
  include $(INC_GIT)
endif
ifneq ("$(wildcard $(INC_AZURE))","")
  include $(INC_AZURE)
endif
ifneq ("$(wildcard $(INC_LATEX))","")
  include $(INC_LATEX)
endif
ifneq ("$(wildcard $(INC_PDF))","")
  include $(INC_PDF)
endif
ifneq ("$(wildcard $(INC_DOCKER))","")
  include $(INC_DOCKER)
endif
ifneq ("$(wildcard $(INC_JEKYLL))","")
  include $(INC_JEKYLL)
endif
ifneq ("$(wildcard $(INC_MLHUB))","")
  include $(INC_MLHUB)
endif
ifneq ("$(wildcard $(INC_WEBCAM))","")
  include $(INC_WEBCAM)
endif
ifneq ("$(wildcard $(INC_INSTALL))","")
  include $(INC_INSTALL)
endif

