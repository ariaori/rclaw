# Claude Code Development Guidelines for rclaw

This document provides instructions for Claude Code (and other AI assistants) when working on the rclaw iOS application. Following these guidelines ensures consistency, maintainability, and proper documentation.

## Core Principle

**⚠️ CRITICAL RULE: Any code changes MUST be accompanied by corresponding README.md updates.**

This keeps documentation synchronized with the codebase and helps new engineers understand the project without requiring extensive code exploration.

## Documentation Update Requirements

### When to Update README.md

You MUST update `README.md` when making any of the following changes:

#### 1. Adding New Features or Modules
- [ ] Add feature to "Implemented" section if complete
- [ ] Add feature to "To Be Implemented" if in progress
- [ ] Update "Key Features" section
- [ ] Add new file documentation to "Project Structure"
- [ ] Update "Code Architecture Details" with new component explanation
- [ ] Update "Future Development Roadmap" if applicable

**Example:**
```markdown
### Implemented
- ✅ **Receipt Detail View** - Full receipt view with edit/delete capabilities
```

#### 2. Modifying Architecture or Structure
- [ ] Update "Project Architecture" section
- [ ] Update "Project Structure" tree diagram
- [ ] Modify "Code Architecture Details" for changed components
- [ ] Update file path references if files moved

**Example:**
```markdown
├── Services/                      # NEW: API and business logic services
│   ├── AuthService.swift         # Authentication and token management
│   └── ReceiptService.swift      # Receipt CRUD operations
```

#### 3. Changing Categories or Business Logic
- [ ] Update "IRS Business Expense Categories" table
- [ ] Modify category list in code examples
- [ ] Update deduction notes if tax rules change
- [ ] Add version note to "Last Updated" section

**Example:**
```markdown
| Home Office | Line 30 | Dedicated workspace expenses | Simplified or actual method |
```

#### 4. Adding Dependencies or Changing Tech Stack
- [ ] Update "Technology Stack" section
- [ ] Add installation instructions if needed
- [ ] Update "Prerequisites" section
- [ ] Modify build commands if process changes

**Example:**
```markdown
### Technology Stack
- **Language:** Swift 5.0
- **Framework:** SwiftUI
- **Database:** Realm Swift 10.45.0  ← ADDED
```

#### 5. Modifying Build or Run Instructions
- [ ] Update "Building and Running" section
- [ ] Modify command-line examples
- [ ] Update Xcode version requirements
- [ ] Add new troubleshooting items if needed

**Example:**
```bash
# NEW: Install dependencies via Swift Package Manager
xcodebuild -resolvePackageDependencies
```

#### 6. Implementing "To Be Implemented" Features
- [ ] Move feature from "To Be Implemented" to "Implemented"
- [ ] Add detailed implementation notes in architecture section
- [ ] Update roadmap to reflect progress
- [ ] Add usage instructions for new feature

**Example:**
```diff
- ⏳ **Authentication System** - User registration and login
+ ✅ **Authentication System** - Firebase auth with email/password and OAuth
```

### What NOT to Update in README

Do NOT clutter README.md with:
- ❌ Bug fixes that don't change functionality
- ❌ Code refactoring that doesn't change architecture
- ❌ Formatting or style changes
- ❌ Comment additions/modifications
- ❌ Performance optimizations (unless they change usage patterns)
- ❌ Minor text/UI copy changes

For these changes, update code comments only.

## Common Pitfalls & Rules to Avoid Errors

### Swift Syntax

**❌ NEVER use escaped backslashes in SwiftUI property wrappers or key paths:**
```swift
// ❌ WRONG
@Environment(\\.dismiss) var dismiss
ForEach(items, id: \\.self) { item in }

// ✅ CORRECT
@Environment(\.dismiss) var dismiss
ForEach(items, id: \.self) { item in }
```

**❌ NEVER use ClosedRange directly in ForEach:**
```swift
// ❌ WRONG - ClosedRange doesn't conform to RandomAccessCollection
ForEach(2020...2030, id: \.self) { year in }

// ✅ CORRECT - Convert to Array first
ForEach(Array(2020...2030), id: \.self) { year in }
```

**❌ NEVER use NSNull in Codable/Encodable contexts:**
```swift
// ❌ WRONG - NSNull doesn't conform to Encodable
.update(["field": NSNull()])

// ✅ CORRECT - Use Optional.none with explicit type
.update(["field": Optional<String>.none])
```

### Supabase Integration

**❌ NEVER name your client class "SupabaseClient":**
```swift
// ❌ WRONG - Conflicts with Supabase SDK's SupabaseClient
class SupabaseClient {
    let client: SupabaseClient // Name collision!
}

// ✅ CORRECT - Use a different name
class SupabaseManager {
    let client: SupabaseClient
}
```

**❌ NEVER use deprecated Supabase v2 APIs:**
```swift
// ❌ WRONG - Direct access is deprecated in v2
supabase.database.from("table")
supabase.auth.signIn()
supabase.storage.from("bucket")

// ✅ CORRECT - Access through client property
supabase.client.from("table")
supabase.client.auth.signIn()
supabase.client.storage.from("bucket")
```

**❌ NEVER manually insert user_profiles during signup when using RLS:**
```swift
// ❌ WRONG - RLS will block this during signup
let user = try await supabase.client.auth.signUp(email: email, password: password)
try await supabase.client.from("user_profiles").insert(profile).execute()

// ✅ CORRECT - Use database trigger + metadata
let user = try await supabase.client.auth.signUp(
    email: email,
    password: password,
    data: ["full_name": .string(name), "role": .string(role)]
)
// Database trigger creates profile automatically with SECURITY DEFINER
```

**Required database trigger for user profiles:**
```sql
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  INSERT INTO public.user_profiles (id, full_name, role)
  VALUES (
    NEW.id,
    NEW.raw_user_meta_data->>'full_name',
    NEW.raw_user_meta_data->>'role'
  );
  RETURN NEW;
END;
$$;

CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();
```

### Vision Framework

**❌ NEVER import only VisionKit for OCR:**
```swift
// ❌ WRONG - Missing Vision framework
import VisionKit
let request = VNRecognizeTextRequest() // Error: VNRecognizeTextRequest not found

// ✅ CORRECT - Import both Vision and VisionKit
import Vision
import VisionKit
let request = VNRecognizeTextRequest()
```

### SwiftUI Previews

**⚠️ Disable problematic previews with @MainActor:**
```swift
// ⚠️ May cause "ambiguous use of init" errors
#Preview {
    let service = AuthService() // @MainActor class
    ChatView(authService: service)
}

// ✅ CORRECT - Comment out or use proper async preview
// #Preview {
//     ChatView(authService: AuthService())
// }
```

### Struct Initializers

**❌ NEVER create structs with parameters but only provide empty init():**
```swift
// ❌ WRONG - Can't initialize with parameters
struct MessageMetadata: Codable {
    var scanResults: ScanResults?
    var imageUrl: String?

    init() {
        self.scanResults = nil
        self.imageUrl = nil
    }
}
let meta = MessageMetadata(scanResults: results, imageUrl: url) // Error!

// ✅ CORRECT - Provide parameterized initializer
struct MessageMetadata: Codable {
    var scanResults: ScanResults?
    var imageUrl: String?

    init() {
        self.scanResults = nil
        self.imageUrl = nil
    }

    init(scanResults: ScanResults? = nil, imageUrl: String? = nil) {
        self.scanResults = scanResults
        self.imageUrl = imageUrl
    }
}
```

## Code Standards

### File Headers and Comments

Add file headers for new Swift files:

```swift
//
//  FileName.swift
//  rclaw
//
//  Purpose: Brief description of what this file does
//  Created: YYYY-MM-DD
//

import SwiftUI

// MARK: - Main Component Name
/// Detailed description of this component's purpose and usage
struct ComponentName: View {
    // Implementation
}
```

### SwiftUI View Documentation

Document complex views with:

```swift
/// Displays receipt details with edit and delete capabilities
///
/// This view shows:
/// - Receipt image thumbnail
/// - Merchant name and date
/// - Category and amount
/// - Action buttons for edit/delete
///
/// - Parameters:
///   - receipt: The receipt model to display
///   - onDelete: Callback when receipt is deleted
struct ReceiptDetailView: View {
    // Implementation
}
```

### State Management Documentation

Document state variables:

```swift
/// Current authentication state. When true, shows HomeView; when false, shows LoginView
@State private var isLoggedIn = false

/// Selected category filter for receipt list. Defaults to "All"
@State private var selectedCategory = "All"

/// Currently displayed receipt. Nil when no receipt is selected
@State private var selectedReceipt: Receipt? = nil
```

### Business Logic Comments

Add comments for IRS tax rules or complex logic:

```swift
// Per IRS Publication 463, business meals are 50% deductible
// Entertainment expenses are generally non-deductible since Tax Cuts and Jobs Act 2017
let deductionPercentage = category == "Meals & Entertainment" ? 0.50 : 1.00

// Schedule C Line 9: Car and truck expenses
// Must choose either actual expenses or standard mileage rate (67¢/mile for 2024)
func calculateAutoExpense(miles: Double, actualExpenses: Double?) -> Double {
    // Implementation
}
```

## Testing Requirements

Before marking any implementation as complete:

### 1. Manual Testing Checklist
- [ ] Build succeeds without warnings
- [ ] App runs on iPhone SE (small screen)
- [ ] App runs on iPhone 15 Pro Max (large screen)
- [ ] App runs on iPad (if applicable)
- [ ] All navigation flows work correctly
- [ ] No crashes or console errors
- [ ] SwiftUI previews render correctly

### 2. Build Commands to Run

```bash
# Clean build
xcodebuild clean -project rclaw.xcodeproj -scheme rclaw

# Build for simulator
xcodebuild -project rclaw.xcodeproj \
           -scheme rclaw \
           -sdk iphonesimulator \
           -destination 'platform=iOS Simulator,name=iPhone 15' \
           build

# Look for warnings or errors in output
```

### 3. Simulator Testing

Test on multiple devices:
```bash
# iPhone SE (smallest modern iPhone)
xcrun simctl boot "iPhone SE (3rd generation)"

# iPhone 15 (standard size)
xcrun simctl boot "iPhone 15"

# iPad (tablet layout)
xcrun simctl boot "iPad Pro (12.9-inch)"
```

## Git Commit Guidelines

### Commit Message Format

Use conventional commit format:

```
<type>(<scope>): <subject>

<body>

README: <what was updated in README.md>
```

**Types:**
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation only
- `refactor`: Code refactoring
- `style`: Formatting changes
- `test`: Adding tests
- `chore`: Build/tooling changes

**Example:**
```
feat(processing): Add IRS expense category filtering

- Implemented 15 IRS Schedule C expense categories
- Added horizontal scrolling category chips
- Updated PhotoProcessingView with tax-compliant categories

README: Updated IRS Business Expense Categories table,
added new categories to PhotoProcessingView documentation,
updated feature list to reflect IRS-compliant categorization
```

## Feature Implementation Workflow

When implementing a new feature, follow this sequence:

### 1. Planning Phase
```
1. Read current README.md thoroughly
2. Identify which sections will be affected
3. Check MVVM architecture requirements
4. Plan state management approach
5. Draft README updates before coding
```

### 2. Implementation Phase
```
1. Create/modify Swift files with proper documentation
2. Add inline comments for complex logic
3. Implement SwiftUI previews
4. Test on simulator
5. Build and verify no warnings
```

### 3. Documentation Phase
```
1. Update README.md per guidelines above
2. Update "Last Updated" date in README
3. Increment version if applicable
4. Review CLAUDE.md compliance
5. Commit with proper message format
```

### 4. Verification Phase
```
1. Read updated README as a new engineer would
2. Verify all code references are accurate
3. Check for broken links or references
4. Ensure examples match actual code
5. Confirm build instructions still work
```

## Architecture Patterns to Follow

### MVVM Separation

As the app grows, maintain MVVM architecture:

```
Views/           → UI components (SwiftUI)
ViewModels/      → Business logic, state management
Models/          → Data structures
Services/        → API calls, data persistence
```

**Example ViewModel:**
```swift
// ViewModels/ReceiptListViewModel.swift
import SwiftUI
import Combine

/// Manages receipt list state and business logic
/// Fetches receipts, handles filtering, and manages selection
@MainActor
class ReceiptListViewModel: ObservableObject {
    @Published var receipts: [Receipt] = []
    @Published var selectedCategory: String = "All"
    @Published var isLoading: Bool = false

    private let receiptService: ReceiptService

    // Implementation
}
```

### SwiftUI Best Practices

1. **Extract complex views:**
   ```swift
   // Instead of nested VStacks, extract to separate view
   struct ReceiptCard: View { /* ... */ }
   ```

2. **Use @ViewBuilder for conditional content:**
   ```swift
   @ViewBuilder
   var receiptContent: some View {
       if isLoading {
           ProgressView()
       } else {
           ReceiptList(receipts: receipts)
       }
   }
   ```

3. **Prefer @State for view-local state:**
   ```swift
   @State private var showingAlert = false  // View-local
   @StateObject private var viewModel = ReceiptViewModel()  // View lifecycle
   ```

## IRS Tax Compliance Notes

When working with tax categories or calculations:

### Important Considerations

1. **Meals & Entertainment:**
   - Generally 50% deductible for business meals
   - Client entertainment is NOT deductible (post-TCJA 2017)
   - Keep separate categories if possible

2. **Vehicle Expenses:**
   - Standard mileage: 67¢/mile (2024 rate - update annually)
   - Actual expenses: Gas, insurance, repairs, depreciation
   - Cannot switch methods mid-year for same vehicle

3. **Home Office:**
   - Must be exclusive and regular use
   - Simplified: $5/sq ft up to 300 sq ft
   - Actual: Calculate percentage of home used

4. **Depreciation:**
   - Equipment over $2,500: Depreciate over useful life
   - Under $2,500: Deduct immediately (de minimis safe harbor)
   - Section 179: Up to $1,160,000 immediate expensing (2024)

### Documentation Requirements

For any tax-related code, cite IRS publications:

```swift
// Per IRS Publication 535 (Business Expenses), office supplies are 100% deductible
// Publication 463 covers travel, meals, and entertainment
// Publication 587 covers home office deductions
```

## Emergency Contacts and Resources

### When Stuck

1. **iOS Development:**
   - [Apple SwiftUI Documentation](https://developer.apple.com/documentation/swiftui)
   - [Swift.org Language Guide](https://docs.swift.org/swift-book/)

2. **IRS Tax Information:**
   - [IRS Publication 535 - Business Expenses](https://www.irs.gov/publications/p535)
   - [IRS Publication 463 - Travel, Meals, Entertainment](https://www.irs.gov/publications/p463)
   - [Schedule C Instructions](https://www.irs.gov/forms-pubs/about-schedule-c-form-1040)

3. **Xcode Build Issues:**
   - Clean derived data: `rm -rf ~/Library/Developer/Xcode/DerivedData`
   - Reset package caches: `File → Packages → Reset Package Caches`
   - Check code signing: `Preferences → Accounts`

## Version Control Rules

### Before Committing

- [ ] Run build and fix all warnings
- [ ] Test on at least 2 simulator devices
- [ ] Update README.md if required (per rules above)
- [ ] Review diff to ensure no debug code remains
- [ ] Check for sensitive data (API keys, tokens)
- [ ] Verify .gitignore excludes build artifacts

### Branch Naming

```
feature/short-description    # New features
fix/issue-description        # Bug fixes
refactor/component-name      # Code refactoring
docs/what-changed            # Documentation updates
```

### What to Commit

✅ **DO commit:**
- Source files (.swift)
- Project files (.xcodeproj)
- Assets (.xcassets)
- Documentation (.md)
- Configuration files

❌ **DO NOT commit:**
- Build artifacts (build/, DerivedData/)
- User-specific files (.xcuserdata/)
- OS files (.DS_Store)
- Sensitive data (API keys, secrets)

## Questions to Ask Before Implementing

Before implementing a feature, consider:

1. **Does this change affect tax categories or calculations?**
   → If yes, verify with IRS publications and document sources

2. **Does this change the app architecture?**
   → If yes, update architecture diagrams and README structure section

3. **Does this add new dependencies?**
   → If yes, document in README and consider app size impact

4. **Does this change user flow?**
   → If yes, update "Testing User Flow" in README

5. **Does this change build/run process?**
   → If yes, update build instructions and troubleshooting

## Final Checklist

Before considering work complete:

- [ ] Code compiles without errors or warnings
- [ ] SwiftUI previews work for new/modified views
- [ ] Tested on iPhone SE and iPhone 15 simulators
- [ ] README.md updated (if applicable per rules)
- [ ] Code comments added for complex logic
- [ ] IRS tax rules cited for financial calculations
- [ ] No hardcoded secrets or API keys
- [ ] Git commit message follows conventional format
- [ ] "Last Updated" date changed in README

---

**Remember:** Good documentation is as important as good code. Future engineers (and your future self) will thank you for keeping README.md synchronized with the codebase.

**Last Updated:** March 29, 2026
