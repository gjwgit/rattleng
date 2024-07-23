# RattleNG Installers

RattleNG is a re-implementation of Rattle using the modern Flutter
framework for Dart. Flutter supports multiple platforms so that
Flutter based apps will run native and similarly on Linux, MacOS, and
Windows. 

## Prerequisite

RattleNG relies on running R locally and so it requires R to be
installed on your computer. At present R is supported on desktops
(Linux, MacOS, and Windows). You can download R from the [R
statistical software](https://cloud.r-project.org/) repository. 

Once R is installed, open a terminal and run the R command. You can then
install the pre-requisite packages for Rattle by pasting the following after the
prompt `> `:

```bash
R -e 'install.packages(c("rattle", "magrittr", "janitor", "tidyverse",
                         "mice", "VIM", "naniar", "reshape", "corrplor",
                         "Hmisc", "fBasics", "descr", "randomForest",
                         "verification", "magrittr", "janitor", "rpart",
                         "readr", "tm", "wordcloud", "magick"))'
```

RattleNG can then be installed from the installation packages
available from Togaware as described below.

## Linux

### Prerequisite

+ Install R. For Debian/Ubuntu: `wajig install r-recommended`
+ Install prerequisite R packages from the operating system or else
  using the above R command if you don't have admin access.

```bash
sudo apt install r-cran-rattle r-cran-magrittr r-cran-janitor \
	 r-cran-tidyverse r-cran-vim r-cran-hmisc r-cran-mice \
	 r-cran-reshape
```

### Tar Install

Download
[rattleng.tar.gz](https://access.togaware.com/rattleng.tar.gz):

```bash
wget https://access.togaware.com/rattleng.tar.gz -O rattleng.tar.gz
```

**Quick Start**

To try it out:

```bash
wget https://access.togaware.com/rattleng.tar.gz -O rattleng.tar.gz
tar zxvf rattleng.tar.gz
```

Then simply run the executable:

```bash
rattleng/rattle
```

**Local User Install**

To install for the local user the package can be placed into `~/.local/share`:

```bash
wget https://access.togaware.com/rattleng.tar.gz -O rattleng.tar.gz
tar zxvf rattleng.tar.gz -C ${HOME}/.local/share/
```

These two steps can also be repeated to **update** your installation.

Set up a link to the binary to be able to run the `rattle` command
from a terminal:

```bash
ln -s ${HOME}/.local/share/rattleng/rattle ${HOME}/.local/bin/
```

Then set up your local installation (only required once) to make it
known to GNOME and KDE, with a desktop icon for your desktop:

```bash
wget https://raw.githubusercontent.com/gjwgit/rattleng/dev/installers/rattle.desktop -O ${HOME}/.local/share/applications/rattle.desktop
sed -i "s/USER/$(whoami)/g" ${HOME}/.local/share/applications/rattle.desktop
mkdir -p ${HOME}/.local/share/icons/hicolor/256x256/apps/
wget https://github.com/gjwgit/rattleng/raw/dev/installers/rattle.png -O ${HOME}/.local/share/icons/hicolor/256x256/apps/rattle.png
```

**System Install**

To install for any user on the computer begin by downloading the
**.tar.gz** and installing that into `/opt/` or wherever your system
suggests optional installations live:

```bash
wget https://access.togaware.com/rattleng.tar.gz -O rattleng.tar.gz
sudo tar zxvf rattleng.tar.gz -C /opt/
```

Those two steps can also be repeated to **update** your installation.

Then set up your local installation (only required once):

```bash
sudo ln -s /opt/rattleng/rattle /usr/local/bin/
sudo mkdir -p /usr/local/share/applications/
sudo wget https://raw.githubusercontent.com/gjwgit/rattleng/dev/installers/rattleng.desktop -O /usr/local/share/applications/rattle.desktop
sudo wget https://github.com/gjwgit/rattleng/raw/dev/installers/rattle.png -O /opt/rattleng/rattle.png
``` 

If installing somewhere other than`/opt/` you will need to modify the
steps and edit the `rattle.desktop`.

Once installed users can run the app from the GNOME desktop through
the Window key then type `rattle`.

### Snap Install - UNDER DEVELOPMENT

+ Install RattleNG with `snap install --dangerous rattle.snap`

The *dangerous* refers to side-loading the app from outside of the
snap store. This will not be required for the snap store version but
for this development version we are side-loading the package.

## MacOS

### Zip Install

```bash
wget https://access.togaware.com/rattleng-macos.zip
```

Unzip and run rattle.

### Dmg Install - UNDER DEVELOPMENT

The package file `rattleng.dmg` can be installed on MacOS. Download
the file and open it on your Mac. Then, holding the Control key click
on the app icon to display a menu. Choose `Open`. Then accept the
warning to then run the app. The app should then run without the
warning next time.

## Windows

### Prerequisite

+ Download and install R
  + Visit https://cloud.r-project.org/ and navigate to Windows install
  + Click on *Download R for Windows*
  + Open the downloaded file to install R into the suggested path
    *C:\Program Files\R*
  + Add *C:\Program Files\R\bin* to the PATH environment variable
    + Open *Edit the system environment variables* from **Control panel**
	+ Click *Environment Variables...*
	+ Click the *Path* entry and then *Edit...*
    + Click *New* and then add *C:\Program Files\R\bin*
    + Click *OK* a few times to close the windows.

### Zip Install

```bash
wget https://access.togaware.com/rattleng-windows.zip
```

Unzip and run `rattle.exe`. You can add the unzipped path to the
system PATH environment variable.

### Inno Install - UNDER DEVELOPMENT 

Download and run the `rattleng.exe` to self install the app on
Windows.

### Msix Install - UNDER DEVELOPMENT

+ Download https://rattle.togaware.com/rattle.msix
+ Add the rattle certificate to your store:
  + Right click the downloaded file in Explorer
  + Choose *Properties*
  + Choose the *Digital Signatures* tab. 
  + Highlight the *Togaware* line
  + Click *Details*. 
  + Click *View Certificate...* 
  + Click *Install Certificate...*
  + Choose *Local Machine*
  + Click *Next*
  + Choose *Place all certificates in the following store*
  + Click *Browse...*
  + Select **Trusted Root Certification Authorities**
  + Click *OK*
  + Click *Next* and *Finish*.
  + A popup says **The import was successful**
+ Open the downloaded `rattle.msix` to install and run rattle
  + Or in PowerShell: `Add-AppxPackage -Path .\rattle.msix`

