BINARY?=FileConverter
PROJECT?=FileConverter
BUILD_FOLDER?=.build
PREFIX?=/usr/local
RELEASE_BINARY_FOLDER?=$(BUILD_FOLDER)/release/$(PROJECT)

.PHONEY: open_package
open_package:
	open Package.swift

update:
	swift package update

build:
	swift build -c release

clean:
	swift package clean
	rm -rf $(BUILD_FOLDER) $(PROJECT).xcodeproj

install: update build
	sudo mkdir -p $(PREFIX)/bin
	sudo cp -f $(RELEASE_BINARY_FOLDER) $(PREFIX)/bin/$(BINARY)

uninstall:
	rm -f $(PREFIX)/bin/$(BINARY)

.PHONEY: build_iphonesimulator
build_iphonesimulator:
	swift build -v -Xswiftc "-sdk" -Xswiftc "`xcrun --sdk iphonesimulator --show-sdk-path`" -Xswiftc "-target" -Xswiftc "x86_64-apple-ios14.0-simulator"