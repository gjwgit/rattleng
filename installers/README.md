# RattleNG Installers

RattleNG is a new implementation of Rattle using the modern Flutter
framework for Dart. Flutter supports multiple platforms so that
Flutter based apps will run native and similarly on Linux, MacOS, and
Windows.

RattleNG relies on running R locally separate to the RattleNG
application.  That is, it requires R to be installed on your computer.
R can be installed on Linux, MacOS, and Windows. See the [Installing
R](https://survivor.togaware.com/datascience/installing-r.html)
section of the Data Science Desktop Survival Guide for details on
installing R.

RattleNG will attempt to install any missing R packages whenever it
starts up. For those packages it installs it won't need to attempt to
install them again (next startup). You can check this in the
**Console** tab. However you may need to install one R package before
starting RattleNG for the first time to initialise your local R
folder, since otherwise (without a default local R library) Rattle
will fail to load the packages.  See the [Installing
Rattle](https://survivor.togaware.com/datascience/installing-rattle.html)
section of the Data Science Desktop Survival Guide. Specific operating
system instructions are also available:

+ [GNU/Linux](https://survivor.togaware.com/datascience/installing-rattle-on-linux.html)
+ [MacOS](https://survivor.togaware.com/datascience/installing-rattle-on-macos.html)
+ [Windows](https://survivor.togaware.com/datascience/installing-rattle-on-windows.html)

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
