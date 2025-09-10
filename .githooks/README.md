The git hooks are located in a non-standard place (other than
.git/hooks) so that they can be added to github. Seems like files in
.git can not be added to github.

To enable the hooks in here to be run by git, ensure you first run:

git config core.hooksPath .githooks

To check the current path:

git config core.hooksPath

And to unset the variable:

git config --unset core.hooksPath

The default folder for githooks is .git/hooks.

20250627 gjw
