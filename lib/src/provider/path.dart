import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// part 'path.g.dart';

// Define a StateProvider for path
final pathProvider = StateProvider<String>((ref) {
  return 'XXXX';
});

/// Annotating a class by `@riverpod` defines a new shared state for your application,
/// accessible using the generated [counterProvider].
/// This class is both responsible for initializing the state (through the [build] method)
/// and exposing ways to modify it (cf [increment]).
// @riverpod
// class Path extends _$Path {
//   /// Classes annotated by `@riverpod` **must** define a [build] function.
//   /// This function is expected to return the initial state of your shared state.
//   /// It is totally acceptable for this function to return a [Future] or [Stream] if you need to.
//   /// You can also freely define parameters on this method.
//   @override
//   String build() => '';

//   void increment() => "YYYY";
// }
