# Rattle Installers

To install Rattle visit the [survival
guide](https://survivor.togaware.com/datascience/installing-rattle.html). Specific
instructions are available for each of the major computer operating
systems.

- [**GNU/Linux**](https://survivor.togaware.com/datascience/installing-rattle-on-linux.html);
- [**MacOS**](https://survivor.togaware.com/datascience/installing-rattle-on-macos.html);
- [**Windows**](https://survivor.togaware.com/datascience/installing-rattle-on-windows.html).

The Rattle front-end is implemented in [Flutter](https://flutter.dev/)
with the back-end implemented in [R](https://r-project.org/). You will
need to install R on your computer to be able to run Rattle, as
covered in the above instructions. To install R in general please
visit the guide to [installing
R](https://survivor.togaware.com/datascience/installing-r.html). If
you are on Gnu?Linux and particularly Ubuntu then visit the guide to
[installing R on
Ubuntu](https://survivor.togaware.com/datascience/installing-r-with-cran-on-ubuntu.html).

## Source Install

You can run the app from the source code available from
[github](https://github.com/gjwgit/rattleng). This has been tested on
Linux, MacOS, and Windows. Begin by installing flutter on your
computer (see the [flutter install
guide](https://docs.flutter.dev/get-started/install)), then clone the
github repository (see the [git install
guide](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git))
and then build/run the app:

```bash
git clone git@github.com:gjwgit/rattleng.git
cd rattleng
flutter run
```

You can also download the source code (rather than cloning the
repository) from [github](https://github.com/gjwgit/rattleng) by
clicking the _Code_ drop down menu then the _Download ZIP_
button. Then unzip, cd into the unzip'ed folder `rattleng-dev` to
then run `flutter run`.
