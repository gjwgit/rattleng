#!/bin/bash

## 20250210 TODO gjw Grab the version from pubspec.

VER=$(egrep '^version:' ../pubspec.yaml | cut -d' ' -f2 | cut -d'+' -f1)

# Build the release.

(cd ..; flutter build linux --release)

# Create debian package structure.

mkdir -p rattle_${VER}_amd64/DEBIAN
mkdir -p rattle_${VER}_amd64/usr/bin
mkdir -p rattle_${VER}_amd64/usr/share/applications
mkdir -p rattle_${VER}_amd64/usr/share/icons/hicolor/512x512/apps

# Create control file.

cat > rattle_${VER}_amd64/DEBIAN/control << EOL
Package: rattle
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

cat > rattle_${VER}_amd64/usr/share/applications/rattle.desktop << EOL
[Desktop Entry]
Name=Rattle
Comment=Rattle Data Science
Exec=/usr/bin/rattle
Icon=rattle
Terminal=false
Type=Application
Categories=Utility;
EOL

# Copy the built flutter application.

cp -r ../build/linux/x64/release/bundle/* rattle_${VER}_amd64/usr/bin/

# Copy the app icon (assuming you have an icon file named rattle.png).

cp rattle.png rattle_${VER}_amd64/usr/share/icons/hicolor/512x512/apps/

# Set correct permissions.

chmod 755 rattle_${VER}_amd64/usr/bin/rattle
chmod -R 755 rattle_${VER}_amd64/DEBIAN
find rattle_${VER}_amd64/usr -type d -exec chmod 755 {} \;
find rattle_${VER}_amd64/usr -type f -exec chmod 644 {} \;
chmod 755 rattle_${VER}_amd64/usr/bin/rattle

# Build the debian package.

dpkg-deb --build rattle_${VER}_amd64

# Cleanup.

rm -rf rattle_${VER}_amd64
