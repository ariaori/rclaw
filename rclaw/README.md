# Receipt Claw (rclaw)

A native iOS application designed to help small businesses (LLCs and Corporations) manage receipt photos and categorize expenses for tax purposes. Built with SwiftUI and Supabase, this app provides an intuitive interface for CPAs and business owners to track deductible business expenses aligned with IRS categories.

## Overview

Receipt Claw is a multi-tenant receipt management and expense tracking application that uses Apple's Vision framework to automatically extract information from receipt photos and categorize them according to IRS business expense categories. This makes tax preparation simpler for CPAs and business owners.

**Current Status:** Version 2.0 - Backend Integration Complete
This version implements full Supabase backend integration with authentication, database storage, multi-tenant company management, and OCR-powered receipt scanning.

## Key Features

### Implemented
- ✅ **Authentication System** - Full Supabase auth with email/password, signup, and login
- ✅ **Multi-Tenant Architecture** - Company-based organization with admin/employee roles
- ✅ **Company Onboarding** - Admin users create and configure companies
- ✅ **Receipt Upload & Scanning** - Camera/photo library integration with Vision OCR
- ✅ **Auto-Categorization** - AI-powered expense categorization based on merchant detection
- ✅ **Receipt Management** - View, edit, and delete receipts with full CRUD operations
- ✅ **Subscription Tracking** - Manage recurring business subscriptions
- ✅ **Chat Interface** - Conversational UI for receipt management and queries
- ✅ **Cloud Storage** - Supabase Storage for receipt images organized by company
- ✅ **IRS Tax Categories** - 14 business expense categories aligned with Schedule C
- ✅ **Environment Management** - Staging/production environment switching
- ✅ **Automated UI Tests** - Comprehensive test suite for signup, navigation, and accessibility

### To Be Implemented
- ⏳ **Employee Invitations** - Invite team members to join company
- ⏳ **Export/Reporting** - CPA-ready tax reports and CSV exports
- ⏳ **Receipt Search** - Full-text search across receipt data
- ⏳ **Analytics Dashboard** - Spending trends and category breakdowns
- ⏳ **Mileage Tracking** - GPS-based mileage logging for auto expenses
- ⏳ **Receipt Approval Workflow** - Multi-level approval for expense reimbursements

## Project Architecture

### Technology Stack
- **Language:** Swift 5.0
- **Framework:** SwiftUI
- **Backend:** Supabase (PostgreSQL, Auth, Storage)
- **OCR:** Apple Vision Framework
- **Minimum iOS:** 17.2
- **Xcode:** 15.2 or later
- **Architecture Pattern:** MVVM with Services layer
- **Testing:** XCTest with UI Tests

### Project Structure

```
rclaw/
├── rclaw.xcodeproj/              # Xcode project configuration
│   ├── project.pbxproj            # Build settings and file references
│   └── xcshareddata/              # Shared schemes for testing
│
├── rclaw/                         # Main source directory
│   ├── rclawApp.swift            # App entry point with Supabase auth callback
│   │
│   ├── Views/                     # SwiftUI view components
│   │   ├── ContentView.swift     # Root view with auth/company state management
│   │   ├── LoginView.swift       # Supabase authentication UI
│   │   ├── CompanyOnboardingView.swift  # Company creation flow
│   │   ├── ChatView.swift        # Main chat interface
│   │   ├── ChatBubble.swift      # Chat message component
│   │   ├── PhotoCaptureView.swift     # Camera integration
│   │   ├── ImagePicker.swift     # UIKit photo picker wrapper
│   │   ├── PhotoProcessingView.swift  # Receipt categorization
│   │   ├── ReceiptListView.swift      # Receipt browsing
│   │   ├── SubscriptionListView.swift # Subscription management
│   │   └── CompanySettingsView.swift  # Company configuration
│   │
│   ├── Models/                    # Data models
│   │   ├── Receipt.swift         # Receipt model with IRS categories
│   │   ├── Company.swift         # Multi-tenant company model
│   │   ├── UserProfile.swift     # User profile with roles
│   │   ├── Subscription.swift    # Recurring subscription model
│   │   └── ChatMessage.swift     # Chat message with metadata
│   │
│   ├── Services/                  # Business logic and API layer
│   │   ├── SupabaseClient.swift  # Supabase client configuration
│   │   ├── AuthService.swift     # Authentication management
│   │   ├── CompanyService.swift  # Company CRUD operations
│   │   └── ReceiptService.swift  # Receipt upload, OCR, and management
│   │
│   ├── Info.plist                # App configuration
│   └── Assets.xcassets/          # App icons and image assets
│
├── rclawUITests/                 # Automated UI tests
│   ├── rclawUITests.swift        # Test suite (signup, navigation, accessibility)
│   └── Info.plist
│
├── README.md                      # This file
├── CLAUDE.md                      # AI assistant development guidelines
├── STAGING_PROD_WORKFLOW.md       # Environment management guide
└── truncate_staging.sql           # SQL script to clear staging data
```

## Code Architecture Details

### 1. App Entry Point
**File:** `rclaw/rclawApp.swift`
- Uses `@main` attribute to define the app entry point
- Creates a `WindowGroup` scene with `ContentView` as the root
- Handles Supabase auth deep link callbacks via `.onOpenURL` modifier

### 2. Backend Configuration
**File:** `rclaw/Services/SupabaseClient.swift`

**SupabaseManager Singleton:**
- Manages Supabase client instance
- Environment switching between staging and production
- Configuration:
  - **Staging:** `qczbfdvlmdaflcvlkrtx.supabase.co`
  - **Production:** TBD (configured in STAGING_PROD_WORKFLOW.md)
- Debug logging for environment verification

**Environment Management:**
```swift
enum SupabaseEnvironment {
    case staging
    case production
    static let current: SupabaseEnvironment = .staging  // Change to switch
}
```

### 3. Root View & Navigation Flow
**File:** `rclaw/Views/ContentView.swift`

**Three-Tier Navigation:**
1. **Not Authenticated** → Shows `LoginView`
2. **Authenticated, No Company** → Shows `CompanyOnboardingView`
3. **Authenticated, Has Company** → Shows `ChatView`

**Service Objects:**
- `@StateObject private var authService: AuthService` - Auth state management
- `@StateObject private var companyService: CompanyService` - Company operations
- `@StateObject private var receiptService: ReceiptService` - Receipt operations

### 4. Authentication System
**File:** `rclaw/Services/AuthService.swift` + `rclaw/Views/LoginView.swift`

**AuthService (@MainActor):**
- `@Published var isAuthenticated: Bool` - Auth state
- `@Published var currentUser: User?` - Supabase user object
- Sign up: `signUp(email:password:fullName:role:) async throws`
- Sign in: `signIn(email:password:) async throws`
- Sign out: `signOut() async throws`
- Session management with automatic token refresh

**LoginView:**
- Email/password input fields
- Toggle between login and signup modes
- Error display with alerts
- Integrates directly with Supabase Auth API

### 5. Multi-Tenant Company Management
**Files:** `rclaw/Services/CompanyService.swift`, `rclaw/Views/CompanyOnboardingView.swift`

**CompanyService (@MainActor):**
- `@Published var currentCompany: Company?` - Current company context
- Create company: `createCompany(name:address:taxId:adminUserId:) async throws`
- Load company: `loadUserCompany(userId:) async throws`
- Update settings: `updateSettings(_:) async throws`

**Company Model:**
- `id: UUID` - Primary key
- `name, address, taxId` - Company details
- `adminUserId: UUID` - Company owner
- `settings: CompanySettings` - Fiscal year, categorization settings

**CompanyOnboardingView:**
- Shown after signup for admin users
- Collects company name, address, tax ID (EIN/SSN)
- Creates company record in database

### 6. Receipt Management System
**File:** `rclaw/Services/ReceiptService.swift`

**ReceiptService (@MainActor):**
- `@Published var receipts: [Receipt]` - Receipt list
- `@Published var isProcessing: Bool` - Upload/scan status

**Key Operations:**
1. **processReceipt(image:userId:companyId:) → (Receipt, ScanResults)**
   - Uploads image to Supabase Storage (`receipts` bucket)
   - Runs Apple Vision OCR to extract text
   - Parses merchant name, amount, date
   - Suggests IRS category based on merchant keywords
   - Creates receipt record in database

2. **loadReceipts(companyId:) async throws**
   - Fetches all receipts for a company
   - Orders by creation date (newest first)

3. **updateReceipt(_:) async throws**
   - Updates receipt fields (category, amount, etc.)

4. **deleteReceipt(id:) async throws**
   - Removes receipt from database

**Vision OCR Processing:**
- Uses `VNRecognizeTextRequest` with accurate recognition
- Parses text with regex patterns:
  - Amount: `$?\d+\.\d{2}`
  - Date: `\d{1,2}/\d{1,2}/\d{2,4}`
- Keyword-based category suggestion:
  - "restaurant" → Meals & Entertainment
  - "hotel" → Travel
  - "gas" → Auto & Mileage
  - etc.

### 7. Receipt Model & IRS Categories
**File:** `rclaw/Models/Receipt.swift`

**Receipt Model:**
```swift
struct Receipt: Codable, Identifiable {
    let id: UUID
    let userId: UUID
    let companyId: UUID
    var imageUrl: String?
    var merchantName: String?
    var amount: Decimal?
    var receiptDate: Date?
    var category: String?
    var isVerified: Bool
    var notes: String?
    let createdAt: Date
    var updatedAt: Date
}
```

**ExpenseCategory Enum:**
- 14 IRS Schedule C-compliant categories
- `deductionPercentage` property (50% for meals, 100% for others)
- `description` with IRS publication references
- Categories: Meals & Entertainment, Travel, Auto & Mileage, Office Supplies, Office Expenses, Utilities, Rent & Lease, Marketing & Advertising, Professional Services, Insurance, Repairs & Maintenance, Taxes & Licenses, Equipment & Supplies, Other

### 8. Chat Interface
**Files:** `rclaw/Views/ChatView.swift`, `rclaw/Views/ChatBubble.swift`

**ChatView:**
- Main interface after login
- Message list with chat bubbles
- Receipt upload button (camera/photo library)
- Receipt list navigation
- Company settings and logout

**ChatBubble:**
- User messages (blue, right-aligned)
- System messages (gray, left-aligned)
- Displays receipt scan results
- Markdown-like formatting support

**ChatMessage Model:**
- `id: UUID`
- `userId: UUID`
- `companyId: UUID`
- `content: String` - Message text
- `role: String` - "user" or "assistant"
- `metadata: MessageMetadata?` - Scan results, image URL

### 9. Photo Capture & Image Picker
**Files:** `rclaw/Views/PhotoCaptureView.swift`, `rclaw/Views/ImagePicker.swift`

**PhotoCaptureView:**
- Camera button → Opens native camera
- Photo library button → Opens photo picker
- Returns selected image to parent view

**ImagePicker:**
- UIKit `UIImagePickerController` wrapper
- SwiftUI representable with `@Binding var image: UIImage?`
- Supports camera and photo library sources

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

**New User Signup & Company Creation:**
1. Launch app → See login screen
2. Toggle to "Sign Up" mode
3. Enter email, password, full name, select "Admin" role
4. Tap "Sign Up" → Account created in Supabase
5. Automatically navigate to Company Onboarding
6. Enter company name, address, tax ID
7. Tap "Create Company" → Company record created
8. Navigate to main chat interface

**Receipt Upload & Processing:**
1. Tap camera icon in chat
2. Choose "Camera" or "Photo Library"
3. Select/capture receipt photo
4. Vision OCR extracts text automatically
5. System suggests category based on merchant
6. Receipt saved to Supabase Storage + database
7. Chat displays scan results (merchant, amount, date, category)
8. Navigate to "View Receipts" to browse all receipts

**Receipt Management:**
1. From chat, tap "View Receipts"
2. See list of all company receipts
3. Tap receipt to view details
4. Edit category, amount, notes
5. Delete receipt if needed
6. Changes saved to Supabase in real-time

**Logout & Login:**
1. From chat, tap settings icon → "Logout"
2. Return to login screen
3. Enter email/password
4. Tap "Sign In" → Authenticated
5. Company data loaded automatically
6. Return to chat interface

## Supabase Backend Architecture

### Database Schema

The app uses PostgreSQL via Supabase with the following tables:

**1. auth.users (Supabase managed)**
- User authentication records
- Stores email, encrypted password, metadata
- Triggers `handle_new_user()` function on insert

**2. user_profiles**
- `id: UUID` (FK to auth.users)
- `full_name: TEXT`
- `role: TEXT` ("admin" or "employee")
- `created_at`, `updated_at: TIMESTAMPTZ`
- RLS: Users can read/update their own profile

**3. companies**
- `id: UUID` (PK)
- `name: TEXT`
- `address: TEXT`
- `tax_id: TEXT` (EIN or SSN)
- `admin_user_id: UUID` (FK to auth.users)
- `settings: JSONB` (fiscal year, categorization settings)
- `created_at`, `updated_at: TIMESTAMPTZ`
- RLS: Company members can read, admin can update

**4. receipts**
- `id: UUID` (PK)
- `user_id: UUID` (FK to auth.users)
- `company_id: UUID` (FK to companies)
- `image_url: TEXT` (Supabase Storage URL)
- `merchant_name: TEXT`
- `amount: NUMERIC(10,2)`
- `receipt_date: DATE`
- `category: TEXT`
- `is_verified: BOOLEAN`
- `notes: TEXT`
- `created_at`, `updated_at: TIMESTAMPTZ`
- RLS: Company members can read/write their company's receipts

**5. subscriptions**
- `id: UUID` (PK)
- `company_id: UUID` (FK to companies)
- `name: TEXT`
- `amount: NUMERIC(10,2)`
- `billing_cycle: TEXT`
- `category: TEXT`
- `next_billing_date: DATE`
- `is_active: BOOLEAN`
- `created_at`, `updated_at: TIMESTAMPTZ`
- RLS: Company members can read/write their company's subscriptions

**6. chat_messages**
- `id: UUID` (PK)
- `user_id: UUID` (FK to auth.users)
- `company_id: UUID` (FK to companies)
- `content: TEXT`
- `role: TEXT` ("user" or "assistant")
- `metadata: JSONB` (scan results, image URLs)
- `created_at: TIMESTAMPTZ`
- RLS: Company members can read/write their company's messages

### Storage Buckets

**receipts**
- Stores receipt images organized by company: `{companyId}/{receiptId}.jpg`
- Public read access for authenticated users
- Upload restricted to receipt owners

### Row Level Security (RLS)

All tables have RLS policies enabled to ensure:
- Users can only access data for their company
- Admins have additional privileges for company settings
- No cross-tenant data leakage

### Database Triggers

**handle_new_user() Function:**
```sql
CREATE FUNCTION public.handle_new_user()
RETURNS trigger AS $$
BEGIN
  INSERT INTO public.user_profiles (id, full_name, role)
  VALUES (
    NEW.id,
    NEW.raw_user_meta_data->>'full_name',
    NEW.raw_user_meta_data->>'role'
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
```
- Automatically creates user profile when auth.users record is created
- Uses SECURITY DEFINER to bypass RLS during signup

## Environment Management

See `STAGING_PROD_WORKFLOW.md` for detailed environment management instructions.

**Quick Switch:**
Edit `rclaw/Services/SupabaseClient.swift`:
```swift
static let current: SupabaseEnvironment = .staging  // or .production
```

**Clearing Staging Data:**
Run `truncate_staging.sql` before testing to ensure clean state:
```bash
# Via Supabase Dashboard SQL Editor
# Or via Claude Code with Supabase MCP
```

## Automated Testing

**Test Suite:** `rclawUITests/rclawUITests.swift`

**Tests Included:**
- `testAppLaunches` - App launch and initial screen
- `testSignupFlow` - Complete signup with unique email
- `testCompanyCreationFlow` - Admin company setup
- `testNavigation` - Screen transitions
- `testEmptyStates` - Empty state messaging
- `testAccessibility` - VoiceOver and accessibility labels
- `testLaunchPerformance` - App launch speed metrics
- `testNavigationPerformance` - Navigation performance

**Running Tests:**
```bash
xcodebuild test -project rclaw.xcodeproj -scheme rclaw \
  -sdk iphonesimulator \
  -destination 'platform=iOS Simulator,name=iPhone 15' \
  -resultBundlePath /tmp/rclaw-test-results.xcresult
```

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

### ✅ Phase 1: Complete (Version 2.0)
- [x] Implement Supabase authentication
- [x] Add camera and photo library integration
- [x] Implement cloud storage (Supabase Storage)
- [x] Add receipt list and detail views
- [x] Integrate OCR service (Apple Vision)
- [x] Implement text extraction and parsing
- [x] Build auto-categorization based on merchant
- [x] Add merchant detection and amount parsing
- [x] Multi-tenant company architecture

### Phase 2: Employee Management & Collaboration
- [ ] Invite employees to join company
- [ ] Role-based permissions (admin, employee, viewer)
- [ ] Receipt approval workflow
- [ ] Team expense reports
- [ ] Expense reimbursement tracking

### Phase 3: CPA Features & Reporting
- [ ] Export receipts by category (CSV, Excel)
- [ ] Generate PDF reports for tax season
- [ ] Add date range filtering
- [ ] Year-end tax report summaries
- [ ] Integration with QuickBooks/Xero
- [ ] CPA firm multi-client management

### Phase 4: Advanced Features
- [ ] Full-text search across receipts
- [ ] Analytics dashboard (spending trends, category breakdowns)
- [ ] Mileage tracking with GPS
- [ ] Recurring expense predictions
- [ ] Budget alerts and notifications
- [ ] Receipt matching with bank transactions

### Phase 5: Enterprise & API
- [ ] RESTful API for third-party integrations
- [ ] Webhook support for external systems
- [ ] SSO/SAML authentication
- [ ] Advanced audit logs
- [ ] Custom categorization rules
- [ ] AI chat assistant for tax questions

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
**Version:** 2.0.0 (Backend Integration Complete)
**Build:** Supabase + Vision OCR + Multi-Tenant Architecture
