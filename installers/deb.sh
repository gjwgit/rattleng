#!/bin/bash

APP=$(pwd | rev | cut -d'/' -f2 | rev)
APP=${APP::-2}

VER=$(egrep '^version:' ../pubspec.yaml | cut -d' ' -f2 | cut -d'+' -f1)

# Build the release.

(cd ..; flutter build linux --release)

# Create debian package structure.

mkdir -p ${APP}_${VER}_amd64/DEBIAN
mkdir -p ${APP}_${VER}_amd64/usr/bin
mkdir -p ${APP}_${VER}_amd64/usr/lib/${APP}
mkdir -p ${APP}_${VER}_amd64/usr/share/applications
mkdir -p ${APP}_${VER}_amd64/usr/share/icons/hicolor/512x512/apps

# Create control file.

cat > ${APP}_${VER}_amd64/DEBIAN/control << EOL
Package: ${APP}
Version: ${VER}
Section: utils
Priority: optional
Architecture: amd64
Depends: libgtk-3-0, libblkid1, liblzma5
Maintainer: Graham Williams <graham.williams@togaware.com>
Description: R Analytic Tool To Learn Easily - Rattle
 A detailed description of Rattle
 spanning multiple lines if needed.
EOL

# Create desktop entry.

cat > ${APP}_${VER}_amd64/usr/share/applications/${APP}.desktop << EOL
[Desktop Entry]
Name=Rattle
Comment=Rattle Data Science
Exec=/usr/bin/${APP}
Icon=${APP}
Terminal=false
Type=Application
Categories=Utility;
EOL

# Copy the built flutter application.

cp -r ../build/linux/x64/release/bundle/* ${APP}_${VER}_amd64/usr/lib/${APP}/

# Ensure /usr/bin/${APP} points to the actual executable.

(cd ${APP}_${VER}_amd64/usr/bin; ln -s ../lib/${APP}/${APP} ${APP})

# Copy the app icon which is assumed to be named ${APP}.png in the
# installers folder.

cp ${APP}.png ${APP}_${VER}_amd64/usr/share/icons/hicolor/512x512/apps/

# Set correct permissions.

chmod -R 755 ${APP}_${VER}_amd64/DEBIAN
find ${APP}_${VER}_amd64/usr -type d -exec chmod 755 {} \;
find ${APP}_${VER}_amd64/usr -type f -exec chmod 644 {} \;
chmod 755 ${APP}_${VER}_amd64/usr/lib/${APP}/${APP}

# Build the debian package.

dpkg-deb --build ${APP}_${VER}_amd64

# Cleanup.

rm -rf ${APP}_${VER}_amd64
