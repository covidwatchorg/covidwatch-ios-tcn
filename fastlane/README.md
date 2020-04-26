fastlane documentation
================
# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```
xcode-select --install
```

Install _fastlane_ using
```
[sudo] gem install fastlane -NV
```
or alternatively using `brew cask install fastlane`

# Available Actions
## iOS
### ios beta
```
fastlane ios beta
```
Push a new beta build to TestFlight
### ios tests
```
fastlane ios tests
```
Run UI and Unit Tests
### ios build
```
fastlane ios build
```
Build Only
### ios lint
```
fastlane ios lint
```
SwiftLint
### ios process_test_coverage
```
fastlane ios process_test_coverage
```
Process Test Coverage Results

----

This README.md is auto-generated and will be re-generated every time [fastlane](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
