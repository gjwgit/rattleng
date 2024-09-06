import 'dart:io';

bool imageExists(String path) {
  return FileSystemEntity.typeSync(path) != FileSystemEntityType.notFound;
}
