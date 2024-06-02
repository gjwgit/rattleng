import 'dart:ffi';
import 'package:ffi/ffi.dart';

// Define the necessary functions and types from GTK.
// Assuming GTK is installed and available on your system.

final DynamicLibrary gtkLib = DynamicLibrary.open('libgtk-3.so');

typedef _gtk_recent_manager_add_item = Int32 Function(
  Pointer<Void>, // GtkRecentManager*
  Pointer<Utf8>, // const gchar*
);
typedef _GtkRecentManagerAddItem = int Function(
  Pointer<Void>, // GtkRecentManager*
  Pointer<Utf8>, // const gchar*
);

final _GtkRecentManagerAddItem gtk_recent_manager_add_item = gtkLib
    .lookup<NativeFunction<_gtk_recent_manager_add_item>>(
        'gtk_recent_manager_add_item')
    .asFunction();

Pointer<Void> gtk_recent_manager_get_default() {
  final Pointer<Void> Function() gtk_recent_manager_get_default = gtkLib
      .lookup<NativeFunction<Pointer<Void> Function()>>(
          'gtk_recent_manager_get_default')
      .asFunction();
  return gtk_recent_manager_get_default();
}

void addRecentFile(String filePath) {
  final manager = gtk_recent_manager_get_default();
  final filePathC = filePath.toNativeUtf8();
  gtk_recent_manager_add_item(manager, filePathC);
  malloc.free(filePathC);
}
