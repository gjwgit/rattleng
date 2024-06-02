########################################################################
#
# Makefile template for Version Control - git
#
# Time-stamp: <Sunday 2021-11-07 05:49:43 AEDT Graham Williams>
#
# Copyright 2018-2024 (c) Graham.Williams@togaware.com
#
# License: Creative Commons Attribution-ShareAlike 4.0 International.
#
########################################################################

define GIT_HELP
git:

  info	    Identify the git repository;
  status    Status listing untracked files;
  qstatus   A quieter status ignoring untracked files;

  enter	    Do a git status, fetch, and rebase
  exit      Do a git status

  push
  pull

  fetch     Update local repo from remote.
  stash     Stash changes to allow a rebase.
  merge     Update local repo with remote updates.
  rebase    Rebase local repo to include remote in history.
  pop       Pop the stash.

  main      Checkout the main branch;
  dev       Checkout the dev branch;
  log
  flog	    Show the full log;
  gdiff
  vdiff	    Show a visual diff using meld.

  upstream  Merge from upstrem to local repo.

endef
export GIT_HELP

help::
	@echo "$$GIT_HELP"

info:
	@echo "-------------------------------------------------------"
	git config --get remote.origin.url
	@echo "-------------------------------------------------------"

status:
	@echo "-------------------------------------------------------"
	git status
	@echo "-------------------------------------------------------"

qstatus:
	@echo "-------------------------------------------------------"
	git status --untracked-files=no
	@echo "-------------------------------------------------------"

enter:: status fetch rebase
exit:: status push

# Use :: to allow push to be augmented in other makefiles.

push::
	@echo "-------------------------------------------------------"
	git push
	@echo "-------------------------------------------------------"

pull:
	@echo "-------------------------------------------------------"
	git pull --stat
	@echo "-------------------------------------------------------"

fetch:
	@echo "-------------------------------------------------------"
	git fetch
	@echo "-------------------------------------------------------"

stash:
	@echo "-------------------------------------------------------"
	git stash
	@echo "-------------------------------------------------------"

rebase:
	@echo "-------------------------------------------------------"
	git rebase
	@echo "-------------------------------------------------------"

pop:
	@echo "-------------------------------------------------------"
	git stash pop
	@echo "-------------------------------------------------------"

main:
	@echo "-------------------------------------------------------"
	git checkout main
	@echo "-------------------------------------------------------"

dev:
	@echo "-------------------------------------------------------"
	git checkout $(USER)/dev
	@echo "-------------------------------------------------------"

log:
	@echo "-------------------------------------------------------"
	git --no-pager log --stat --max-count=10
	@echo "-------------------------------------------------------"

flog:
	@echo "-------------------------------------------------------"
	git --no-pager log
	@echo "-------------------------------------------------------"

gdiff:
	@echo "-------------------------------------------------------"
	git --no-pager diff --color
	@echo "-------------------------------------------------------"

vdiff:
	git difftool --tool=meld

upstream:
	git fetch upstream
	git merge upstream/main
