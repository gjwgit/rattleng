# Rattleng Installers

Flutter supports multiple platform targets and Flutter based apps will
run native on Android, iOS, Linux, MacOS, and Windows, as well as
directly in a browser from the web. While the Flutter functionality is
in theory identical across all platforms, rattleng relies on running R
locally and so it requires R to be installed on your platform. At
present R is supported on the desktops (Linux, MacOS, and Windows).

## Linux tar Archive

+ Download
  [rattleng.tar.gz](https://access.togaware.com/rattleng.tar.gz)

```bash
wget https://access.togaware.com/rattleng.tar.gz
```

Then

```bash
tar zxvf rattleng.tar.gz
(cd rattleng; ./mlfutter)
```

To install for the current user:

```bash
tar zxvf rattleng.tar.gz -C ${HOME}/.local/share/
cat <<EOF > ~/.local/bin/rattleng
#!/bin/bash

(cd ${HOME}/.local/share/rattleng; ./rattle)
EOF
chmod a+rx ${HOME}/.local/bin/rattleng
```

## MacOS

The package file `rattleng.dmg` can be installed on MacOS. Download
the file and open it on your Mac. Then, holding the Control key click
on the app icon to display a menu. Choose `Open`. Then accept the
warning to then run the app. The app should then run without the
warning next time.

## Windows Installer

Download and run the `rattleng.exe` to self install the app on
Windows.
