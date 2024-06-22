# Rattleng Installers

Flutter supports multiple platform targets and Flutter based apps will
run native on Android, iOS, Linux, MacOS, and Windows, as well as
directly in a browser from the web. While the Flutter functionality is
in theory identical across all platforms, rattleng relies on running R
locally and so it requires R to be installed on your platform. At
present R is supported on the desktops (Linux, MacOS, and Windows).

## Prerequisite

Install R. See the instructions from the [R
Project](https://cloud.r-project.org/).

## Linux tar Archive

Download [rattleng.tar.gz](https://access.togaware.com/rattleng.tar.gz)

To try it:

```bash
wget https://access.togaware.com/rattleng.tar.gz
tar zxvf rattleng.tar.gz
rattleng/rattle
```

To install for the local user and to make it known to Gnome and KDE,
with a desktop icon:

```bash
wget https://access.togaware.com/rattleng.tar.gz
tar zxvf rattleng.tar.gz -C ${HOME}/.local/share/
ln -s ${HOME}/.local/share/rattleng/rattle ${HOME}/.local/bin/
wget https://raw.githubusercontent.com/gjwgit/rattleng/dev/installers/rattle.desktop -O ${HOME}/.local/share/applications/rattle.desktop
sed -i "s/USER/$(whoami)/g" ${HOME}/.local/share/applications/rattle.desktop
mkdir -p ${HOME}/.local/share/icons/hicolor/256x256/apps/
wget https://github.com/gjwgit/rattleng/raw/dev/installers/rattle.png -O ${HOME}/.local/share/icons/hicolor/256x256/apps/rattle.png
```

To install for any user on the computer:

```bash
sudo tar zxvf rattleng.tar.gz -C /opt/
sudo ln -s /opt/rattleng/rattle /usr/local/bin/
``` 

The `rattle.desktop` and app icon can be installed into
`/usr/local/share/applications/` and `/usr/local/share/icons/`
respectively.

Once installed you can run the app through Alt-F2 and type `rattle`
then Enter.

## MacOS

The package file `rattleng.dmg` can be installed on MacOS. Download
the file and open it on your Mac. Then, holding the Control key click
on the app icon to display a menu. Choose `Open`. Then accept the
warning to then run the app. The app should then run without the
warning next time.

## Windows Installer

Download and run the `rattleng.exe` to self install the app on
Windows.
