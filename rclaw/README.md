# Receipt Claw (rclaw)

A native iOS application designed to help small businesses (LLCs and Corporations) manage receipt photos and categorize expenses for tax purposes. Built with SwiftUI, this app provides an intuitive interface for CPAs and business owners to track deductible business expenses aligned with IRS categories.

## Overview

Receipt Claw is a receipt management and expense tracking application that will eventually use AI to automatically extract information from receipt photos and categorize them according to IRS business expense categories. This makes tax preparation simpler for CPAs and business owners.

**Current Status:** Version 1.0 - Prototype Phase
This initial version establishes the UI/UX foundation with placeholder modules for future implementation.

## Key Features

### Implemented
- ✅ **Login Screen** - Clean authentication UI with demo login bypass
- ✅ **Home Dashboard** - Central navigation hub with feature cards
- ✅ **Photo Capture Module** - UI framework for camera/photo library integration
- ✅ **Receipt Processing Module** - IRS-compliant category filtering and receipt viewing
- ✅ **IRS Tax Categories** - 15 business expense categories aligned with Schedule C

### To Be Implemented
- ⏳ **Authentication System** - User registration, login, and account management
- ⏳ **Camera Integration** - Native camera access and photo library selection
- ⏳ **AI/OCR Processing** - Text extraction, amount detection, merchant identification
- ⏳ **Auto-Categorization** - Machine learning-based expense categorization
- ⏳ **Data Persistence** - Local/cloud storage for receipts and expense data
- ⏳ **Export/Reporting** - CPA-ready tax reports and CSV exports

## Project Architecture

### Technology Stack
- **Language:** Swift 5.0
- **Framework:** SwiftUI
- **Minimum iOS:** 17.2
- **Xcode:** 15.2 or later
- **Architecture Pattern:** MVVM (prepared for future implementation)

### Project Structure

```
rclaw/
├── rclaw.xcodeproj/              # Xcode project configuration
│   └── project.pbxproj            # Build settings and file references
│
├── rclaw/                         # Main source directory
│   ├── rclawApp.swift            # App entry point (@main)
│   │
│   ├── Views/                     # SwiftUI view components
│   │   ├── ContentView.swift     # Root view with auth state management
│   │   ├── LoginView.swift       # Authentication UI (placeholder)
│   │   ├── PhotoCaptureView.swift    # Camera integration UI (placeholder)
│   │   └── PhotoProcessingView.swift # Receipt viewing and categorization
│   │
│   ├── Models/                    # Data models (prepared for future use)
│   ├── ViewModels/                # Business logic layer (prepared for future use)
│   │
│   └── Assets.xcassets/           # App icons and image assets
│       ├── Contents.json
│       └── AppIcon.appiconset/
│
├── README.md                      # This file
└── CLAUDE.md                      # AI assistant development guidelines
```

## Code Architecture Details

### 1. App Entry Point
**File:** `rclaw/rclawApp.swift`
- Uses `@main` attribute to define the app entry point
- Creates a `WindowGroup` scene with `ContentView` as the root

### 2. Root View & Navigation
**File:** `rclaw/Views/ContentView.swift`

#### ContentView
- Manages authentication state with `@State private var isLoggedIn`
- Uses `NavigationStack` for iOS 16+ navigation
- Conditionally displays `LoginView` or `HomeView` based on auth state

#### HomeView
- Main dashboard after login
- Contains two feature buttons using `NavigationLink`:
  - **Capture Receipt** → `PhotoCaptureView()`
  - **View Receipts** → `PhotoProcessingView()`
- Logout button resets `isLoggedIn` to false

#### FeatureButton (Reusable Component)
- Custom SwiftUI view for feature cards
- Props: `icon`, `title`, `subtitle`, `color`
- Displays SF Symbol icon, text, and chevron in a card layout

### 3. Login Module
**File:** `rclaw/Views/LoginView.swift`

**State Management:**
- `@Binding var isLoggedIn: Bool` - Passed from ContentView
- `@State private var email: String` - Email input (disabled)
- `@State private var password: String` - Password input (disabled)

**Current Behavior:**
- Fields are disabled (`.disabled(true)`)
- "Demo Login" button sets `isLoggedIn = true`
- Sign-up button is disabled
- Clear placeholder notices inform users module is not implemented

**Future Implementation:**
- Enable email/password fields
- Add validation logic
- Integrate authentication service (Firebase, Auth0, custom backend)
- Implement token management and secure storage

### 4. Photo Capture Module
**File:** `rclaw/Views/PhotoCaptureView.swift`

**State Management:**
- `@Environment(\.dismiss) var dismiss` - For navigation dismissal
- `@State private var showingCamera: Bool` - Alert state

**Current Behavior:**
- Two disabled buttons:
  - "Open Camera" - Will trigger camera sheet
  - "Choose from Library" - Will trigger photo picker
- Alert informs users camera integration is coming soon

**Future Implementation:**
- Add `UIImagePickerController` wrapper or `PhotosPicker`
- Implement camera permission handling
- Add image preview and cropping
- Pass captured image to processing module

### 5. Receipt Processing Module
**File:** `rclaw/Views/PhotoProcessingView.swift`

**IRS Tax Categories:**
```swift
let categories = [
    "All",                          // View all receipts
    "Meals & Entertainment",        // 50% deductible business meals
    "Travel",                       // Airfare, hotels, transportation
    "Auto & Mileage",              // Vehicle expenses, mileage
    "Office Supplies",             // Stationery, printer ink
    "Office Expenses",             // Software, postage, phone
    "Utilities",                   // Electricity, water, internet
    "Rent & Lease",                // Office space, equipment leases
    "Marketing & Advertising",     // Ads, promotional materials
    "Professional Services",       // CPA, legal, consulting fees
    "Insurance",                   // Business liability, property
    "Repairs & Maintenance",       // Building/equipment maintenance
    "Taxes & Licenses",            // Business licenses, property tax
    "Equipment & Supplies",        // Tools, machinery
    "Other"                        // Miscellaneous expenses
]
```

**State Management:**
- `@State private var selectedCategory = "All"` - Current filter

**UI Components:**
- Horizontal scrolling category chips
- Empty state with feature list
- Placeholder notice for AI processing

**CategoryChip Component:**
- Reusable pill-shaped button
- Shows selected state with blue background
- Props: `title`, `isSelected`, `action`

**FeatureItem Component:**
- Icon + text row for feature descriptions
- Props: `icon` (SF Symbol), `text`

**Future Implementation:**
- Fetch and display receipts from database
- Filter by selected category
- Show receipt cards with thumbnail, merchant, amount, date
- Tap to view full receipt details
- Edit/delete functionality
- Export filtered receipts

## IRS Business Expense Categories

The app uses 15 primary categories based on **IRS Schedule C** (Profit or Loss from Business) and corporate tax return line items:

| Category | IRS Schedule C Line | Examples | Deduction Notes |
|----------|---------------------|----------|-----------------|
| Meals & Entertainment | Line 24b | Restaurant receipts, client dinners | 50% deductible |
| Travel | Line 24a | Hotels, flights, rental cars | 100% deductible |
| Auto & Mileage | Line 9 | Gas, repairs, insurance | Actual or standard mileage |
| Office Supplies | Line 18 | Paper, pens, ink cartridges | 100% deductible |
| Office Expenses | Line 18 | Software, postage, phone bills | 100% deductible |
| Utilities | Line 25 | Electricity, water, internet | Based on business use % |
| Rent & Lease | Line 20b | Office rent, equipment leases | 100% deductible |
| Marketing & Advertising | Line 8 | Ads, website, business cards | 100% deductible |
| Professional Services | Line 17 | CPA fees, legal fees, consultants | 100% deductible |
| Insurance | Line 15 | Liability, property, professional | 100% deductible |
| Repairs & Maintenance | Line 21 | Building/equipment maintenance | 100% deductible |
| Taxes & Licenses | Line 23 | Business licenses, property tax | 100% deductible |
| Equipment & Supplies | Line 22 | Tools, machinery under $2,500 | Section 179/Bonus depreciation |
| Other | Line 27a | Bank fees, dues, subscriptions | 100% deductible |

## Building and Running

### Prerequisites
- macOS 12.0 (Monterey) or later
- Xcode 15.2 or later
- iOS Simulator or physical iOS device running iOS 17.2+

### Build from Command Line

```bash
# Navigate to project directory
cd /path/to/rclaw

# Build for simulator
xcodebuild -project rclaw.xcodeproj \
           -scheme rclaw \
           -sdk iphonesimulator \
           -destination 'platform=iOS Simulator,name=iPhone 15' \
           build

# Or use the derivedDataPath for organized builds
xcodebuild -project rclaw.xcodeproj \
           -scheme rclaw \
           -sdk iphonesimulator \
           -destination 'platform=iOS Simulator,name=iPhone 15' \
           -derivedDataPath ./build \
           build
```

### Run on Simulator

```bash
# Boot simulator (if not running)
xcrun simctl boot "iPhone 15"

# Open Simulator app
open -a Simulator

# Install app
xcrun simctl install booted ./build/Build/Products/Debug-iphonesimulator/rclaw.app

# Launch app
xcrun simctl launch booted com.rclaw.app
```

### Open in Xcode

```bash
open rclaw.xcodeproj
```

Then press `⌘R` to build and run.

## Development Workflow

### Using Xcode
1. Open `rclaw.xcodeproj` in Xcode
2. Select target device/simulator from the scheme menu
3. Press `⌘R` to build and run
4. Use `⌘B` to build only
5. SwiftUI previews available in each view file (Canvas)

### Testing User Flow
1. Launch app → See login screen
2. Tap "Demo Login" → Navigate to home dashboard
3. Tap "Capture Receipt" → See camera placeholder
4. Navigate back → Return to home
5. Tap "View Receipts" → See category filters
6. Swipe through categories → Filter chips change state
7. Tap "Logout" → Return to login screen

## Bundle Identifier
- **Production:** `com.rclaw.app`
- **Development Team:** Requires configuration in Xcode signing settings

## Code Style Guidelines

### SwiftUI Conventions
- Use `@State` for view-local state
- Use `@Binding` for parent-child data passing
- Use `@Environment` for system values
- Extract reusable components into separate structs
- Use `#Preview` macros for SwiftUI previews (Xcode 15+)

### Naming Conventions
- Views: `PascalCase` with "View" suffix (e.g., `LoginView`)
- State variables: `camelCase` with descriptive names (e.g., `isLoggedIn`)
- Constants: `camelCase` (e.g., `categories`)
- Functions: `camelCase` with verb prefix (e.g., `handleLogin()`)

### File Organization
- One view per file
- Related components can be in the same file (e.g., `FeatureButton` in `ContentView.swift`)
- Models in `Models/` directory
- ViewModels in `ViewModels/` directory
- Networking/Services in future `Services/` directory

## Future Development Roadmap

### Phase 2: Core Functionality
- [ ] Implement real authentication (Firebase/Auth0)
- [ ] Add camera and photo library integration
- [ ] Implement local storage (CoreData/Realm)
- [ ] Add receipt list and detail views

### Phase 3: AI Integration
- [ ] Integrate OCR service (Vision API/Tesseract)
- [ ] Implement text extraction and parsing
- [ ] Build auto-categorization ML model
- [ ] Add merchant detection and amount parsing

### Phase 4: CPA Features
- [ ] Export receipts by category
- [ ] Generate PDF reports
- [ ] Add date range filtering
- [ ] Implement receipt notes and tags
- [ ] Multi-user support for CPA firms

### Phase 5: Advanced Features
- [ ] Cloud sync (iCloud/custom backend)
- [ ] Receipt search and filtering
- [ ] Analytics dashboard
- [ ] Mileage tracking integration
- [ ] API for third-party integrations

## Troubleshooting

### Build Errors
- **Missing Xcode Command Line Tools:**
  ```bash
  xcode-select --install
  ```

- **Simulator Not Found:**
  ```bash
  xcrun simctl list devices
  ```

- **Code Signing Issues:**
  Open project in Xcode → Signing & Capabilities → Select development team

### Runtime Issues
- **App Crashes on Launch:**
  Check console logs in Xcode (`⌘ + Shift + C`) or use:
  ```bash
  xcrun simctl spawn booted log stream --predicate 'process == "rclaw"'
  ```

- **Simulator Too Slow:**
  Use iPhone 15 or newer simulators, close other apps, increase allocated RAM in Xcode preferences

## Contributing

When making changes to this codebase:
1. **Read `CLAUDE.md`** for AI assistant development guidelines
2. **Update this README** when adding new features or changing architecture
3. **Add code comments** for complex logic
4. **Test on multiple simulators** (iPhone SE, iPhone 15, iPad)
5. **Use SwiftUI previews** for rapid iteration

## License

[Specify your license here]

## Contact

[Your contact information or support links]

---

**Last Updated:** March 29, 2026
**Version:** 1.0.0 (Prototype)
**Build:** Initial Release
