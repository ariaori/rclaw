# Files to Add to Xcode Project

## ⚠️ IMPORTANT: These files must be manually added to your Xcode project!

All source files have been created in the file system, but Xcode doesn't know about them yet.

---

## 📝 Checklist

### Models/ (5 files)
- [ ] Models/UserProfile.swift
- [ ] Models/Company.swift
- [ ] Models/Receipt.swift
- [ ] Models/Subscription.swift
- [ ] Models/ChatMessage.swift

### Services/ (4 files)
- [ ] Services/SupabaseClient.swift ⭐ (Has your API key configured)
- [ ] Services/AuthService.swift
- [ ] Services/CompanyService.swift
- [ ] Services/ReceiptService.swift

### Views/ (7 new files)
- [ ] Views/ChatView.swift ⭐ (Main chat interface)
- [ ] Views/ChatBubble.swift
- [ ] Views/ImagePicker.swift
- [ ] Views/CompanyOnboardingView.swift
- [ ] Views/CompanySettingsView.swift
- [ ] Views/ReceiptListView.swift
- [ ] Views/SubscriptionListView.swift

### Modified Files (2 files)
- [x] Views/ContentView.swift (Updated to use new architecture)
- [x] Views/LoginView.swift (Updated with real authentication)

---

## 🚀 How to Add Files to Xcode

### Method 1: Drag & Drop Entire Folders (Recommended)

1. Open Xcode: `open rclaw.xcodeproj`
2. In Xcode Project Navigator, right-click **rclaw** folder
3. Select **"Add Files to 'rclaw'..."**
4. Navigate to `/Users/kunfang/Desktop/cc/rclaw/rclaw/`
5. Select **Models** folder (hold Command to select multiple)
6. Also select **Services** folder
7. Check these options:
   - ✅ **Copy items if needed**
   - ✅ **Create groups** (not folder references)
   - ✅ **Add to targets: rclaw**
8. Click **Add**

9. Repeat for **Views/** folder:
   - Select only the NEW files (ChatView.swift, ChatBubble.swift, etc.)
   - ContentView.swift and LoginView.swift are already in the project

### Method 2: Use Xcode File Browser

1. Open Xcode
2. **File** → **Add Files to "rclaw"...**
3. Browse to each file and add individually
4. Ensure "Add to targets: rclaw" is checked

---

## ✅ Verification

After adding files, verify in Xcode:

1. **Project Navigator** should show:
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
│   ├── CompanyOnboardingView.swift
│   ├── CompanySettingsView.swift
│   ├── ReceiptListView.swift
│   ├── SubscriptionListView.swift
│   ├── PhotoCaptureView.swift
│   └── PhotoProcessingView.swift
└── Assets.xcassets/
```

2. Build the project: **Product** → **Build** (⌘B)
   - Should see 0 errors (may have warnings about unused code)

3. If you see "Cannot find '...' in scope":
   - File wasn't added to target
   - Right-click file → **Target Membership** → Check **rclaw**

---

## 📦 Dependencies

Don't forget to add the Supabase Swift SDK:

1. **File** → **Add Package Dependencies...**
2. Enter URL: `https://github.com/supabase/supabase-swift`
3. Version: **2.0.0** or later
4. Click **Add Package**
5. Select **rclaw** target
6. Wait for SPM to resolve (2-5 minutes)

---

## 🛠️ Common Issues

### "File not found" errors

**Solution**: Files exist but weren't added to Xcode project. Follow steps above.

### "Duplicate symbol" errors

**Solution**: File was added twice. Remove duplicate in Project Navigator.

### Build errors about missing imports

**Solution**: Add Supabase Swift SDK via Swift Package Manager.

---

## 📊 File Counts

- **Total new files**: 16
- **Models**: 5
- **Services**: 4
- **Views**: 7
- **Modified existing**: 2

---

## ⏱️ Estimated Time

- Adding files to Xcode: **5 minutes**
- Installing Supabase SDK: **5 minutes**
- First build: **2 minutes**
- **Total**: ~12 minutes

---

## 🎯 Next Steps After Adding Files

1. ✅ Add all files to Xcode (see above)
2. ✅ Install Supabase Swift SDK
3. ✅ Add camera permissions to Info.plist
4. ✅ Build project (⌘B)
5. ✅ Run on simulator (⌘R)
6. ✅ Test signup flow
7. ✅ Upload test receipt

See **SETUP_GUIDE.md** for detailed instructions!

---

**Last Updated**: March 29, 2026
