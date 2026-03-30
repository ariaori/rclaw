# RClaw Setup Guide

Complete setup instructions for the RClaw iOS expense tracking application with Supabase backend.

## 📋 Table of Contents

1. [Overview](#overview)
2. [Prerequisites](#prerequisites)
3. [Supabase Configuration](#supabase-configuration)
4. [Xcode Project Setup](#xcode-project-setup)
5. [Adding Files to Xcode](#adding-files-to-xcode)
6. [Installing Dependencies](#installing-dependencies)
7. [Configuring Supabase Client](#configuring-supabase-client)
8. [Testing the App](#testing-the-app)
9. [Troubleshooting](#troubleshooting)

---

## Overview

Your RClaw app now includes:

### ✅ Backend (Supabase)
- Multi-tenant database with Row Level Security
- User authentication via Supabase Auth
- Receipt image storage
- 5 custom tables: companies, user_profiles, receipts, subscriptions, chat_messages

### ✅ iOS Features
- Chat-based UI for receipt management
- Apple Vision Framework for receipt scanning
- Company and member management
- Recurring subscription tracking
- IRS-compliant expense categorization

---

## Prerequisites

Before starting, ensure you have:

- [x] macOS with Xcode 15.2 or later
- [x] iOS 17.2+ deployment target
- [x] Supabase account and project (already connected: `qczbfdvlmdaflcvlkrtx.supabase.co`)
- [x] Swift Package Manager (included with Xcode)

---

## Supabase Configuration

### Step 1: Get Your Supabase Anon Key

1. Go to your Supabase dashboard: https://supabase.com/dashboard/project/qczbfdvlmdaflcvlkrtx
2. Navigate to **Settings** → **API**
3. Copy the **anon public** key (starts with `eyJ...`)

### Step 2: Verify Database Tables

All tables have been created via migrations. Verify in Supabase:

```
Dashboard → Table Editor
```

You should see:
- ✅ user_profiles
- ✅ companies
- ✅ receipts
- ✅ subscriptions
- ✅ chat_messages

### Step 3: Check Storage Bucket

```
Dashboard → Storage
```

You should see:
- ✅ `receipts` bucket (private, 10MB limit)

---

## Xcode Project Setup

### Step 1: Open Project in Xcode

```bash
cd /Users/kunfang/Desktop/cc/rclaw
open rclaw.xcodeproj
```

### Step 2: Add Swift Package Dependencies

1. In Xcode, go to **File** → **Add Package Dependencies...**
2. Add Supabase Swift SDK:
   ```
   https://github.com/supabase/supabase-swift
   ```
3. Select version: **2.0.0** or later
4. Add to target: **rclaw**

Wait for SPM to resolve packages (may take a few minutes).

---

## Adding Files to Xcode

All source files have been created, but need to be added to the Xcode project.

### Method 1: Drag and Drop (Recommended)

1. In Finder, navigate to `/Users/kunfang/Desktop/cc/rclaw/rclaw/`
2. In Xcode, right-click the `rclaw` group in Project Navigator
3. Select **Add Files to "rclaw"...**
4. Add the following folders:
   - **Models/** (5 files)
   - **Services/** (4 files)
5. For **Views/**, add these new files:
   - ChatView.swift
   - ChatBubble.swift
   - ImagePicker.swift
   - CompanySettingsView.swift
   - CompanyOnboardingView.swift
   - ReceiptListView.swift
   - SubscriptionListView.swift
6. Ensure **Copy items if needed** is checked
7. Add to targets: **rclaw**

### Method 2: Terminal Command

```bash
cd /Users/kunfang/Desktop/cc/rclaw
xed .
```

Then manually add files using Xcode's "Add Files" menu.

### Verify File Structure

Your Xcode Project Navigator should look like:

```
rclaw/
├── rclawApp.swift
├── Models/
│   ├── UserProfile.swift
│   ├── Company.swift
│   ├── Receipt.swift
│   ├── Subscription.swift
│   └── ChatMessage.swift
├── Services/
│   ├── SupabaseClient.swift
│   ├── AuthService.swift
│   ├── CompanyService.swift
│   └── ReceiptService.swift
├── Views/
│   ├── ContentView.swift
│   ├── LoginView.swift
│   ├── ChatView.swift
│   ├── ChatBubble.swift
│   ├── ImagePicker.swift
│   ├── CompanySettingsView.swift
│   ├── CompanyOnboardingView.swift
│   ├── ReceiptListView.swift
│   ├── SubscriptionListView.swift
│   ├── PhotoCaptureView.swift (existing)
│   └── PhotoProcessingView.swift (existing)
└── Assets.xcassets/
```

---

## Configuring Supabase Client

### Step 1: Update SupabaseClient.swift

Open `/Users/kunfang/Desktop/cc/rclaw/rclaw/Services/SupabaseClient.swift`

Replace `YOUR_SUPABASE_ANON_KEY_HERE` with your actual anon key:

```swift
let supabaseKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..." // Your actual key
```

### Step 2: Update Info.plist (Camera Permissions)

Add camera usage descriptions:

1. Open **rclaw/Info.plist**
2. Add these keys:

```xml
<key>NSCameraUsageDescription</key>
<string>RClaw needs camera access to scan receipt photos</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>RClaw needs photo library access to upload receipt images</string>
```

Or in Xcode:
- Click project → **rclaw** target → **Info** tab
- Add **Privacy - Camera Usage Description**
- Add **Privacy - Photo Library Usage Description**

---

## Installing Dependencies

### Required Swift Packages

The app requires these dependencies (add via SPM):

1. **Supabase Swift** - Backend and auth
   ```
   https://github.com/supabase/supabase-swift
   ```

2. **Vision Framework** - Built-in (no install needed)

### Install Command

Alternatively, use command line:

```bash
xcodebuild -resolvePackageDependencies -project rclaw.xcodeproj
```

---

## Testing the App

### Step 1: Build the Project

```bash
xcodebuild -project rclaw.xcodeproj \
           -scheme rclaw \
           -sdk iphonesimulator \
           -destination 'platform=iOS Simulator,name=iPhone 15' \
           build
```

Or in Xcode: **Product** → **Build** (⌘B)

### Step 2: Run on Simulator

1. Select **iPhone 15** simulator
2. Click **Run** (⌘R)

### Step 3: Test Authentication Flow

1. **Sign Up**:
   - Email: test@example.com
   - Password: password123
   - Full Name: Test User

2. **Company Setup** (after signup):
   - Company Name: Test Company
   - Address: 123 Main St
   - Tax ID: 12-3456789

3. **Upload Receipt**:
   - Click paperclip icon in chat
   - Choose "Take Photo" or "Choose Photo"
   - Watch AI scan and categorize

### Step 4: Verify Database

Check Supabase dashboard:

```
Table Editor → user_profiles
```

You should see your test user created.

---

## Troubleshooting

### Build Errors

#### Error: "Cannot find 'Supabase' in scope"

**Solution**: Install Supabase Swift SDK via SPM

```bash
# Clean and rebuild
xcodebuild clean -project rclaw.xcodeproj
xcodebuild -resolvePackageDependencies
```

#### Error: "Missing required module 'Vision'"

**Solution**: Vision is iOS-only. Ensure deployment target is iOS 17.2+

```swift
// In project settings
iOS Deployment Target: 17.2
```

#### Error: Compiler errors in Service files

**Solution**: Make sure all import statements are correct:

```swift
import Foundation
import Supabase  // Add this if missing
import Vision   // For ReceiptService
```

### Runtime Errors

#### Auth Error: "Invalid API key"

**Solution**: Double-check your anon key in `SupabaseClient.swift`

#### Storage Error: "Bucket not found"

**Solution**: Verify `receipts` bucket exists in Supabase Storage

#### RLS Error: "Row level security policy violation"

**Solution**: Ensure you're logged in and company_id is set:

```sql
-- Check in Supabase SQL Editor
SELECT * FROM user_profiles WHERE id = 'your-user-id';
```

### Camera Issues

#### Camera not working on simulator

**Note**: Camera doesn't work on iOS Simulator. Use "Choose Photo" instead.

For real device testing:
1. Connect iPhone via USB
2. Select device in Xcode
3. Click Run

#### Permission denied

**Solution**: Check Info.plist has camera descriptions

---

## Next Steps

### Feature Enhancements

1. **Member Invitations**:
   - Implement email invites via Supabase
   - Add invite code system

2. **Advanced OCR**:
   - Integrate OpenAI GPT-4 Vision for better accuracy
   - Train custom ML model

3. **Export Reports**:
   - Generate PDF tax reports
   - Export to Excel/CSV

4. **Real-time Chat**:
   - Use Supabase Realtime for live updates
   - Add push notifications

### Production Checklist

Before deploying to App Store:

- [ ] Remove demo/test credentials
- [ ] Enable Supabase RLS policies
- [ ] Add error tracking (Sentry, Crashlytics)
- [ ] Implement analytics
- [ ] Add App Store screenshots
- [ ] Write privacy policy
- [ ] Test on multiple iOS versions
- [ ] Performance profiling

---

## Architecture Overview

### Database Schema

```
auth.users (Supabase Auth)
    ↓
user_profiles (role: admin/member)
    ↓
companies (admin_user_id)
    ↓
├── receipts (company_id, user_id)
├── subscriptions (company_id, user_id)
└── chat_messages (company_id, user_id)
```

### App Flow

```
Launch
  ↓
LoginView (AuthService)
  ↓
CompanyOnboardingView (if no company)
  ↓
ChatView (main interface)
  ├── Upload Receipt → ReceiptService → Vision Framework
  ├── Manage Subscriptions → SubscriptionService
  └── Company Settings → CompanyService
```

---

## Support

### Resources

- **Supabase Docs**: https://supabase.com/docs
- **SwiftUI Docs**: https://developer.apple.com/documentation/swiftui
- **Vision Framework**: https://developer.apple.com/documentation/vision

### Contact

For issues or questions:
- Check Supabase logs: Dashboard → Logs → API Logs
- Review Xcode console for errors
- File GitHub issues (if applicable)

---

**Last Updated**: March 29, 2026
**App Version**: 2.0.0
**iOS Target**: 17.2+
