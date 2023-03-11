# NXBoot

This application enables provisioning a Tegra X1 powered device with early boot code using an iOS or macOS device. For example, you may use this application to start the Hekate Bootloader or the Lakka Linux Distrobution (RetroArch) on a supported Nintendo Switch.

**Disclaimer:** Early boot code has full access to the device it runs on and can damage it. No boot code is shipped with this application. Responsibility for consequences of using this application and executing boot code remains with the user.

## Released Features

* macOS GUI (made and tested under High Sierra, just allows to select and run payload)



## Prerequisites

* A USB 3 Type A to Type C cable

## Installation

Download latest release and run

## Components

* NXBoot: The feature-complete iOS 11.0+ and Mac Catalyst app
* NXBootCmd: iOS and macOS command line tool for injecting payloads
* NXBootKit: The framework that powers the above tools
* nxboot-gui: GUI app for High Sierra

## License

All included source code is licensed under the GPLv3. Pull requests must be made available under the same license.

## Attribution and Prior Work

CVE-2018-6242 was discovered by Kate Temkin (@ktemkin) and fail0verflow (@fail0verflow). Fusée Gelée was implemented by @ktemkin; ShofEL2 was implemented by @fail0verflow.

JustBrandonT has implemented a proof-of-concept Fusée app for iOS 11.1 and earlier at [GBAtemp](https://gbatemp.net/threads/payload-loader-for-ios.504799/). This application was developed independently of JustBrandonT's work.
