---
name: xcode
description: Build and test iOS apps using xcodebuild CLI commands
---

# Xcode CLI - Build & Test iOS Apps

Quick reference for building and testing iOS apps from the command line using `xcodebuild` and `xcrun`.

## 🚀 Most Common Commands

### Build iOS App

```bash
# Build for simulator (Debug)
xcodebuild -project MyApp.xcodeproj -scheme MyApp -sdk iphonesimulator -configuration Debug

# Build for simulator (Release)
xcodebuild -project MyApp.xcodeproj -scheme MyApp -sdk iphonesimulator -configuration Release

# Build with workspace (for CocoaPods/SPM)
xcodebuild -workspace MyApp.xcworkspace -scheme MyApp -sdk iphonesimulator -configuration Debug

# Clean build
xcodebuild clean -project MyApp.xcodeproj -scheme MyApp
```

### Run Tests

```bash
# Run all tests on iPhone 15 simulator
xcodebuild test \
  -workspace MyApp.xcworkspace \
  -scheme MyApp \
  -destination 'platform=iOS Simulator,name=iPhone 15'

# Run specific test class
xcodebuild test \
  -workspace MyApp.xcworkspace \
  -scheme MyApp \
  -destination 'platform=iOS Simulator,name=iPhone 15' \
  -only-testing:MyAppTests/LoginTests

# Run tests without building (if already built)
xcodebuild test-without-building \
  -workspace MyApp.xcworkspace \
  -scheme MyApp \
  -destination 'platform=iOS Simulator,name=iPhone 15'
```

### Archive & Export (for Distribution)

```bash
# Archive for App Store
xcodebuild archive \
  -workspace MyApp.xcworkspace \
  -scheme MyApp \
  -archivePath ./build/MyApp.xcarchive

# Export IPA
xcodebuild -exportArchive \
  -archivePath ./build/MyApp.xcarchive \
  -exportPath ./build \
  -exportOptionsPlist ExportOptions.plist
```

## 📱 Simulator Management

### List Simulators

```bash
# List all available simulators
xcrun simctl list devices

# List only booted simulators
xcrun simctl list devices | grep Booted

# List available runtimes (iOS versions)
xcrun simctl list runtimes
```

### Control Simulators

```bash
# Boot a simulator
xcrun simctl boot "iPhone 15"

# Shutdown a simulator
xcrun simctl shutdown "iPhone 15"

# Shutdown all simulators
xcrun simctl shutdown all

# Delete and recreate simulator (reset to factory state)
xcrun simctl erase "iPhone 15"

# Install app on simulator
xcrun simctl install "iPhone 15" ./build/MyApp.app

# Launch app on simulator
xcrun simctl launch "iPhone 15" com.company.MyApp

# Open Simulator.app
open -a Simulator
```

## 🔍 Useful Queries

```bash
# List all schemes
xcodebuild -list -project MyApp.xcodeproj

# List all schemes in workspace
xcodebuild -list -workspace MyApp.xcworkspace

# Show build settings
xcodebuild -showBuildSettings -project MyApp.xcodeproj -scheme MyApp

# Show available destinations
xcodebuild -showdestinations -project MyApp.xcodeproj -scheme MyApp
```

## ⚡ Power User Tips

### Parallel Testing
```bash
# Run tests in parallel on multiple simulators
xcodebuild test \
  -workspace MyApp.xcworkspace \
  -scheme MyApp \
  -destination 'platform=iOS Simulator,name=iPhone 15' \
  -destination 'platform=iOS Simulator,name=iPhone 15 Pro' \
  -parallel-testing-enabled YES
```

### Pretty Output with xcpretty
```bash
# Install xcpretty (if not already installed)
gem install xcpretty

# Build with pretty output
xcodebuild -project MyApp.xcodeproj -scheme MyApp | xcpretty

# Test with pretty output and JUnit report
xcodebuild test \
  -workspace MyApp.xcworkspace \
  -scheme MyApp \
  -destination 'platform=iOS Simulator,name=iPhone 15' | \
  xcpretty --report junit
```

### Build for Testing (Separate Build from Test)
```bash
# Build for testing
xcodebuild build-for-testing \
  -workspace MyApp.xcworkspace \
  -scheme MyApp \
  -destination 'platform=iOS Simulator,name=iPhone 15'

# Run tests without rebuilding
xcodebuild test-without-building \
  -workspace MyApp.xcworkspace \
  -scheme MyApp \
  -destination 'platform=iOS Simulator,name=iPhone 15'
```

## 🎯 Common Options

- `-project` - Path to .xcodeproj file
- `-workspace` - Path to .xcworkspace file (use for CocoaPods/SPM)
- `-scheme` - Build scheme name
- `-configuration` - Debug or Release
- `-sdk` - iphoneos or iphonesimulator
- `-destination` - Target device/simulator
- `-derivedDataPath` - Custom build output directory
- `-quiet` - Suppress output
- `-verbose` - Detailed output

## 🔥 Typical Workflow in Claude Code

### 1. Check Available Schemes
```bash
xcodebuild -list -workspace MyApp.xcworkspace
```

### 2. Build the App
```bash
xcodebuild build \
  -workspace MyApp.xcworkspace \
  -scheme MyApp \
  -sdk iphonesimulator \
  -configuration Debug
```

### 3. Run Tests
```bash
xcodebuild test \
  -workspace MyApp.xcworkspace \
  -scheme MyApp \
  -destination 'platform=iOS Simulator,name=iPhone 15'
```

### 4. Check Results
- Build output shows errors/warnings
- Test results show pass/fail counts
- Use exit code to determine success ($? == 0)

## ⚠️ Important Notes

1. **Always use `-workspace`** if you have CocoaPods or Swift Package Manager dependencies
2. **Simulator names matter** - Use exact simulator names from `xcrun simctl list`
3. **Scheme must be shared** - In Xcode: Product → Scheme → Manage Schemes → Check "Shared"
4. **Clean when needed** - Run `xcodebuild clean` if builds behave strangely
5. **Check Xcode version** - Different Xcode versions may have different CLI behavior

## 💡 Troubleshooting

```bash
# If "No scheme specified" error
xcodebuild -list -project MyApp.xcodeproj  # Find available schemes

# If simulator not found
xcrun simctl list devices available  # Find available simulators

# If build fails with signing errors (for testing)
xcodebuild -project MyApp.xcodeproj -scheme MyApp \
  CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO

# If tests hang
xcrun simctl shutdown all  # Reset all simulators
rm -rf ~/Library/Developer/Xcode/DerivedData  # Clear derived data
```

## 🎓 For Claude Code Usage

When the user asks to:
- **Build** → Use `xcodebuild build` with appropriate flags
- **Test** → Use `xcodebuild test` with simulator destination
- **Run** → Build, install on simulator, then launch
- **Clean** → Use `xcodebuild clean` before rebuild

Always check for `-workspace` vs `-project` based on project structure (check for .xcworkspace file first).
