# RattleNG Installers

RattleNG is a new implementation of Rattle using the modern Flutter
framework for Dart. Flutter supports multiple platforms so that
Flutter based apps will run native and similarly on Linux, MacOS, and
Windows. Below we identify the prerequisite to install R on your
computer.

## Prerequisite

RattleNG relies on running R locally and so it requires R to be
installed on your computer. At present R is supported on desktops
(Linux, MacOS, and Windows). You can download R from the [R
statistical software](https://cloud.r-project.org/) repository. 

RattleNG will attempt to install any missing R packages each time it
starts up. For those packages it installs it won't need to attempt to
install them again (next startup). You can check this in the
**Console** tab. However you may need to install one R package before
starting RattleNG for the first time to initialise your local R
folder. For example:

```bash
$ R
...
> install.packages('pacman')
```

For a new install of R this will likely prompt you for a local install
folder. Choose `yes` to go with the defaults. Once setup the `pacman`
package will manage the package installs within RattleNG.

If you want to separately make sure you have the required R packages
installed, once R itself is installed, open a terminal and run the R
command. You can then install the pre-requisite packages for RattleNG
by running the following command line, or pasting just the
`install.packages(...)` part after the R prompt `> ` after starting up
R:

```bash
R -e 'install.packages(c("Hmisc", "VIM",
                         "corrplot", "descr", "fBasics", "ggthemes", "janitor",
                         "magrittr", "mice", "pacman",
                         "randomForest",  "rattle", "readr", "reshape", "rpart",
                         "tidyverse", "tm", "verification", "wordcloud"))'
```

RattleNG can then be installed from the installation packages
available from Togaware as described below.

**NOTE** If the R packages are not installed then RattleNG will
attempt to install them into your local folder for you the first time
it starts up, which can take some time. Check the **Console** tab to
see what is happening.

For reference, these are the packages that should be loaded from the R
library into your **Console**. They should be loaded automatically by
RattleNG and listed here only in case something goes wrong. Do report
an issue if you need to do this manually on your platform.

```r
library(Hmisc)
library(VIM)
library(corrplot)
library(descr)
library(fBasics)
library(ggthemes)
library(janitor)
library(magrittr)
library(mice)
library(pacman)
library(randomForest)
library(rattle)
library(readr)
library(reshape)
library(rpart)
library(tidyverse)
library(tm)
library(verification)
library(wordcloud)
```

## Source Install

You can run the app from the source code available from
[github](https://github.com/gjwgit/rattleng). This has been tested on
Linux, MacOS, and Windows. Begin by installing flutter on your
computer (see the [flutter install
guide](https://docs.flutter.dev/get-started/install)), then clone the
github repository with the git command (see the [git install
guide](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git))
and then build/run the app:

```bash
git clone git@github.com:gjwgit/rattleng.git
cd rattleng
flutter run
```

You can also download the source code from
[github](https://github.com/gjwgit/rattleng) by clicking the *Code*
drop down menu then the *Download ZIP* button. Next unzip, then cd
into the unzip'ed folder `rattleng-dev` to then run `flutter run`.

## Linux

### Prerequisite

+ Install R. For Debian/Ubuntu: `wajig install r-recommended`
+ Install prerequisite R packages from the
  operating system using the `apt` command below. If you don't have
  admin access the above R `install.packages` command will install the
  packages into your account.

```bash
sudo apt install r-cran-magrittr r-cran-tidyverse \
	 r-cran-vim r-cran-hmisc r-cran-mice r-cran-reshape
```

At a minimum, you will need to install `pacman` through R as detailed
in the above prerequisites section.

You are then ready to install the Rattle software using one of the methods below.

### Zip Install

Download
[rattleng-dev-linux.zip](https://access.togaware.com/rattleng-dev-linux.zip):

```bash
wget https://access.togaware.com/rattleng-dev-linux.zip -O rattleng-dev-linux.zip
```

This version was compiled on Ubuntu 20.04 and is known to run on
Ubuntu 22.04, Ubuntu 24.04, and Mint 21.3.

**Quick Start**

To try it out, after downloading the zip file, unzip it locally:

```bash
unzip rattleng-dev-linux.zip -d rattleng
```

Then run the executable:

```bash
rattleng/rattle
```

**Local User Install**

To install for use just by you the package can be placed into
`~/.local/share`. After downloading the **zip** file unzip it into
that location:

```bash
unzip rattleng-dev-linux.zip -d ${HOME}/.local/share/rattleng
```

These two steps, wget and unzip, can also be repeated to **update**
your installation.

Now set up a link to the binary to be able to run the `rattle` command
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
**zip** and unzip that into `/opt/` or wherever your system suggests
optional installations live:

```bash
sudo unzip rattleng-dev-linux.zip -d /opt/rattleng
```

Those two steps, wget and unzip, can also be repeated to **update**
your installation.

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

### Snap Install

Download [rattle_dev_amd64.snap](https://access.togaware.com/rattle_dev_amd64.snap)

```bash
wget https://access.togaware.com/rattle_dev_amd64.snap -O rattle_dev_amd64.snap
```

Install RattleNG with:

```bash
sudo snap install --dangerous rattle_dev_amd64.snap
```

The *dangerous* refers to side-loading the app from outside of the
snap store. This will not be required for the snap store version but
for this development version we are side-loading the package.

Run the app from `/snap/rattle/current/rattle`.

## MacOS

### Prerequisite

+ [Install R](https://cloud.r-project.org/) into **/usr/local/bin/R**
+ Install prerequisite R packages, e.g. "pacman".
+ Test from command line:

```console
$ R
> library(pacman)
```

You are then ready to install the RattleNG software using one of the
methods below. Be sure that R is installed in `/usr/local/bin/R`.

### Zip Install

Download
[rattleng-dev-macos.zip](https://access.togaware.com/rattleng-dev-macos.zip):

```bash
wget https://access.togaware.com/rattleng-dev-macos.zip -O rattleng-dev-macos.zip
```

**Quick Start**

To try it out, after downloading the zip file, unzip it locally:

```bash
unzip rattleng-dev-macos.zip -d rattleng
```

Then run the app:

```bash
open rattleng/rattle.app
```

If the OS complains that the app is not trusted and will not be run,
tap the Security link and allow rattle to be run.

### Dmg Install - UNDER DEVELOPMENT

The package file `rattleng.dmg` can be installed on MacOS. Download
the file and open it on your Mac. Then, holding the Control key click
on the app icon to display a menu. Choose `Open`. Then accept the
warning to then run the app. The app should then run without the
warning next time.

## Windows

### Prerequisite

+  Download and Install R
  + Visit https://cloud.r-project.org/ and navigate to Windows install
  + Click on *Download R for Windows*
  + Open the downloaded **exe** file  **as Administrator**
    + Install R with all the defaults into *C:\Program Files\R*
  + Add *C:\Program Files\R\R-4.4.1\bin* to the PATH environment
    variable (change the version number to match that which you
    installed).
    + Open *Edit the system environment variables* from **Control panel**
	+ Click *Environment Variables...*
	+ Click the *Path* entry and then *Edit...*
    + Click *New* and then add *C:\Program Files\R\R-4.4.1\bin*
    + Click *OK* a few times to close the windows.
+ **As Admin**, start a CMD terminal, run R, and install the required
  R packages with the `install.packages()` command:
  
```r
install.packages(c("Hmisc", "VIM",
                   "corrplot", "descr", "fBasics", "ggthemes", "janitor",
                   "magrittr", "mice", "pacman",
                   "randomForest",  "rattle", "readr", "reshape", "rpart",
                   "tidyverse", "tm", "verification", "wordcloud"))
```
  
Test that this works for the normal user by starting up the CMD
terminal, running R, and then, for example `library(pacman)`.

### Zip Install

Download
[rattleng-dev-windows.zip](https://access.togaware.com/rattleng-dev-windows.zip):

```bash
wget https://access.togaware.com/rattleng-dev-windows.zip -O rattleng-dev-windows.zip
```

**Quick Start**

Unzip the archive and then run `rattle.exe`. You can add the unzipped
path to the system PATH environment variable. 

If the OS complains that the app is not trusted and will not be run,
tap the Security link and allow rattle to be run.

For Windows it is likely the following will be required:

**Trouble Shooting 20240805**

*MSVCP140.dll was not found*

You will need to install the Microsoft Visual C++ libraries for
running the flutter app. See
[answers.microsoft.com](https://answers.microsoft.com/en-us/windows/forum/all/error-message-for-msvcp140dll-and-vcruntime140dll/8c2c0803-08ac-4275-838e-b692077b5c9e). From
there you can download and install one of
[vc_redist.x64.exe](https://aka.ms/vs/16/release/vc_redist.x64.exe) or
[vc_redist.x86.exe](https://aka.ms/vs/16/release/vc_redist.x86.exe).

*Checking R Packages Available*

With the admin install of the R packages, rattle should find the
appropriate packages. Test in the **Console** tab by typing the
following command:

```bash
library(pacman)
```

If the package is not found then be sure to check that you installed
the packages with R as the administrator.

*Unable to Load Dataset*

This can occur on Windows (only) when the R initialisation is not
being done. If you **do not* see in the **Console** the R command like:

```console
> theme_rattle <- theme_economist
```

then R has not initialised the main Rattle script. While we debug why
this is happening, to remedy this, visit
https://github.com/gjwgit/rattleng/blob/dev/assets/r/main.R and copy
the entire contents of this file and paste it into the
**Console**. This should be done as the very first thing on starting
up RattleNG before you attempt to load any datasets.

RattleNG should then be ready to communicate with R. Try loading the
Demo dataset.

This issue is currently being investigated.

*R Packages Not Found*

The R process within the flutter-based RattleNG app is not picking up
local user installed R packages. You may be able to see this if you
compare the output of `.libPaths()` in the RattleNG **Console** tab to
the output when you run R in your CMD window. The RattleNG version may
not have your local path
(e.g. `C:/Users/fred/AppData/Local/R/win-library/4.4`) and it may only
have the system path (e.g., `C:/Program
Files/R/R-4.4.1/library`). A workaround is to ensure your packages are
installed by the Admin user.

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

