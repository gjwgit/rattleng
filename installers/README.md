# Rattleng Installers

Flutter supports multiple platform targets and Flutter based apps will
run native on Android, iOS, Linux, MacOS, and Windows, as well as
directly in a browser from the web. Flutter functionality is essentially identical
across all platforms so the experience across different platforms will
be very similar. RattleNG relies on running R
locally and so it requires R to be installed on your platform. At
present R is supported on the desktops (Linux, MacOS, and Windows).

## Prerequisite

The basic process is to install the [R statistical
software](https://cloud.r-project.org/), then fire up R to install the
pre-requisite packages:

```r
install.packages(c("rattle", "magrittr", "janitor", "tidyverse"))
```

Then you can install the rattleng app from the packages available on
github or snap or build it yourself from source as described below.


## Linux

### Prerequisite

+ Install R
  + Debian/Ubuntu: `wajig install r-recommended`
+ Install required R packages
  + `> install.packages(c("rattle","magrittr","janitor","tidyverse"))`

### Tar Install

Download [rattleng.tar.gz](https://access.togaware.com/rattleng.tar.gz)

To try it out:

```bash
wget https://access.togaware.com/rattleng.tar.gz
tar zxvf rattleng.tar.gz
rattleng/rattle
```

To install for the local user and to make it known to GNOME and KDE,
with a desktop icon for their desktop, begin by downloading the **.tar.gz** and
installing that:

```bash
wget https://access.togaware.com/rattleng.tar.gz
tar zxvf rattleng.tar.gz -C ${HOME}/.local/share/
```

Those two steps can also be repeated to update your installation.

Then set up your local installation (only required once):

```bash
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

Once installed you can run the app from the GNOME desktop through
Alt-F2 and type `rattle` then Enter.

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

