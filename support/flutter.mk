########################################################################
#
# Makefile template for Flutter
#
# Copyright 2021 (c) Graham.Williams@togaware.com
#
# License: Creative Commons Attribution-ShareAlike 4.0 International.
#
########################################################################

define FLUTTER_HELP
flutter:

  android   Run with an attached Android device;
  chrome    Run with the chrome device;
  emu	    Run with the android emulator;
  linux     Run with the linux device;
  qlinux    Run with the linux device and debugPrint() turned off;

  prep       Prep for PR by running tests, checks, docs.

  docs	    Run `dart doc` to create documentation.

  checks    Run all checks over the code base 
    format        Run `dart format`.
    nullable	  Check NULLs from dart_code_metrics.
    unused_code   Check unused code from dart_code_metrics.
    unused_files  Check unused files from dart_code_metrics.
    metrics	  Run analyze from dart_code_metrics.
    analyze       Run flutter analyze.
    ignore        Look for usage of ignore directives.
    license	  Look for missing top license in source code.


  test	    Run `flutter test` for testing.
  itest	    Run `flutter test integration_test` for interation testing.
  qtest	    Run above test with PAUSE=0.

Also supported:

  *.itest
  *.qtest

endef
export FLUTTER_HELP

help::
	@echo "$$FLUTTER_HELP"

.PHONY: chrome
chrome:
	flutter run -d chrome

# 20220503 gjw The following fails if the target files already exist -
# just needs to be run once.
#
# dart run build_runner build --delete-conflicting-outputs
#
# List the files that are automatically generated. Then they will get 
# built as required.

# BUILD_RUNNER = \
# 	lib/models/synchronise_time.g.dart

# $(BUILD_RUNNER):
# 	dart run build_runner build --delete-conflicting-outputs

pubspec.lock:
	flutter pub get

.PHONY: linux
linux: pubspec.lock $(BUILD_RUNNER)
	flutter run -d linux

# Turn off debugPrint() output.

.PHONY: qlinux
qlinux: pubspec.lock $(BUILD_RUNNER)
	flutter run --dart-define DEBUG_PRINT="FALSE" --device-id linux

.PHONY: macos
macos: $(BUILD_RUNNER)
	flutter run --device-id macos

.PHONY: android
android: $(BUILD_RUNNER)
	flutter run -d $(shell flutter devices | grep android | cut -d " " -f 5)

.PHONY: emu
emu:
	@if [ -n "$(shell flutter devices | grep emulator | cut -d" " -f 6)" ]; then \
	  flutter run -d $(shell flutter devices | grep emulator | cut -d" " -f 6); \
	else \
	  flutter emulators --launch Pixel_3a_API_30; \
	  echo "Emulator has been started. Rerun `make emu` to build the app."; \
	fi

.PHONY: linux_config
linux_config:
	flutter config --enable-linux-desktop

.PHONY: prep
prep: checks tests docs

.PHONY: docs
docs::
	dart doc
	chmod -R go+rX doc

.PHONY: format
format:
	dart format lib/

.PHONY: tests
tests:: test qtest

.PHONY: checks
checks: format nullable unused_code unused_files metrics analyze ignore license

.PHONY: nullable
nullable:
	dart run dart_code_metrics:metrics check-unnecessary-nullable --disable-sunset-warning lib

.PHONY: unused_code
unused_code:
	dart run dart_code_metrics:metrics check-unused-code --disable-sunset-warning lib

.PHONY: unused_files
unused_files:
	dart run dart_code_metrics:metrics check-unused-files --disable-sunset-warning lib

.PHONY: metrics 
metrics:
	dart run dart_code_metrics:metrics analyze --disable-sunset-warning lib --reporter=console

.PHONY: analyze 
analyze:
	flutter analyze

.PHONY: ignore
ignore:
	@rgrep ignore: lib

.PHONY: license
license:
	@echo "--\nFiles without a license:"
	@find lib -type f -not -name '*~' ! -exec grep -qE '^(/// .*|/// Copyright|/// Licensed)' {} \; -printf "\t%p\n"

########################################################################
# INTEGRATION TESTING
#
# Run the integration tests for the desktop device (linux, windows,
# macos). Without this explictly specified, if I have my android
# device connected to the computer then the testing defaults to trying
# to install on android. 20230713 gjw

.PHONY: test
test:
	flutter test test

%.itest:
	flutter test --dart-define=PAUSE=5 --device-id \
	$(shell flutter devices | grep desktop | perl -pe 's|^[^•]*• ([^ ]*) .*|\1|') \
	integration_test/$*_test.dart

.PHONY: itest
itest:
	for t in integration_test/*_test.dart; do flutter test --dart-define=PAUSE=5 --device-id \
	$(shell flutter devices | grep desktop | perl -pe 's|^[^•]*• ([^ ]*) .*|\1|') \
	$$t; done

.PHONY: qtest
qtest:
	for t in integration_test/*_test.dart; do flutter test --dart-define=PAUSE=0 --device-id \
	$(shell flutter devices | grep desktop | perl -pe 's|^[^•]*• ([^ ]*) .*|\1|') \
	$$t; done

%.qtest:
	flutter test --dart-define=PAUSE=0 --device-id \
	$(shell flutter devices | grep desktop | perl -pe 's|^[^•]*• ([^ ]*) .*|\1|') \
	integration_test/$*_test.dart

clean::
	flutter clean
	flutter pub get
