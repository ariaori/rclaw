# Staging vs Production Workflow

This document explains how to manage staging and production environments for the rclaw app.

## Overview

The app uses a single Supabase project with environment switching capabilities. Data can be easily cleared for testing using SQL scripts.

## Environment Configuration

### Switching Environments

Edit `rclaw/Services/SupabaseClient.swift`:

```swift
enum SupabaseEnvironment {
    case staging
    case production

    // Change this line to switch environments
    static let current: SupabaseEnvironment = .staging  // or .production
}
```

### Current Setup

**Staging (Default):**
- URL: `https://qczbfdvlmdaflcvlkrtx.supabase.co`
- Use for: Local development and testing
- Data: Can be truncated anytime

**Production (To Be Configured):**
- URL: `https://YOUR_PROD_PROJECT.supabase.co`
- Use for: Live app with real users
- Data: Protected, never truncate

## Clearing Staging Data

### Method 1: Using Supabase SQL Editor

1. Go to: https://supabase.com/dashboard/project/qczbfdvlmdaflcvlkrtx/sql/new
2. Paste the contents of `truncate_staging.sql`
3. Click **Run**
4. All data will be deleted

### Method 2: Using Supabase MCP Tool

If you have Claude Code with Supabase MCP configured:

```sql
-- Run this query
TRUNCATE TABLE chat_messages CASCADE;
TRUNCATE TABLE receipts CASCADE;
TRUNCATE TABLE subscriptions CASCADE;
TRUNCATE TABLE companies CASCADE;
TRUNCATE TABLE user_profiles CASCADE;
DELETE FROM auth.users;
```

### Method 3: Command Line (if Supabase CLI installed)

```bash
supabase db reset --db-url "postgresql://..."
```

## Production Setup (Future)

When ready to deploy to production:

### 1. Create New Supabase Project

1. Go to: https://supabase.com/dashboard
2. Click "New Project"
3. Name it: `rclaw-production`
4. Save the project URL and anon key

### 2. Run All Migrations

Copy and run all migration SQL from:
- Database schema (tables, RLS policies)
- Database triggers (user profile creation)
- Storage buckets and policies

### 3. Update App Configuration

Edit `SupabaseClient.swift`:

```swift
let (url, key) = SupabaseEnvironment.current == .staging
    ? ("https://qczbfdvlmdaflcvlkrtx.supabase.co",  // Staging
       "staging_anon_key")
    : ("https://YOUR_PROD_PROJECT.supabase.co",      // Production
       "production_anon_key")
```

### 4. Switch to Production

```swift
static let current: SupabaseEnvironment = .production
```

### 5. Build and Deploy

```bash
# Clean build for production
xcodebuild clean
xcodebuild -project rclaw.xcodeproj -scheme rclaw build

# Archive for App Store
# (Use Xcode UI: Product > Archive)
```

## Best Practices

### Development Workflow

1. **Always use staging for development**
   ```swift
   static let current: SupabaseEnvironment = .staging
   ```

2. **Truncate staging data before each major test**
   - Run `truncate_staging.sql` before testing signup flows
   - Ensures clean state for testing

3. **Never truncate production data**
   - Production environment should only be used for releases
   - No test users in production

### Testing Workflow

**Before Testing:**
1. Ensure environment is set to `.staging`
2. Run `truncate_staging.sql` to clear old test data
3. Rebuild and run app
4. Test signup, company creation, receipt upload, etc.

**After Testing:**
- Keep test data or truncate for next test session
- Document any issues found

### Release Workflow

**Before Release:**
1. Test thoroughly in staging
2. Switch to `.production`
3. Build production version
4. Archive and submit to App Store

**After Release:**
1. Switch back to `.staging` for continued development
2. Never accidentally deploy staging config to production

## Migration Scripts

All database migrations are documented in:
- Initial migrations in `SETUP_GUIDE.md`
- RLS policies and triggers in migration history
- Can be re-run on new production project

## Monitoring

### Staging
- Check Supabase Dashboard: https://supabase.com/dashboard/project/qczbfdvlmdaflcvlkrtx
- Monitor for: Test user count, table sizes, API usage

### Production (Future)
- Set up alerts for errors
- Monitor user growth
- Track API usage and costs
- Regular database backups

## Troubleshooting

### Wrong Environment

**Symptom:** Test data appearing in production (or vice versa)

**Fix:**
1. Check `SupabaseClient.swift` - verify `current` setting
2. Rebuild app completely (clean build folder)
3. Check app console logs for environment confirmation:
   ```
   🔧 Supabase Environment: staging
   🌐 Supabase URL: https://qczbfdvlmdaflcvlkrtx.supabase.co
   ```

### Can't Clear Staging Data

**Symptom:** SQL truncate commands fail

**Fix:**
1. Check RLS policies aren't blocking admin access
2. Use Supabase Dashboard > Authentication > Users to manually delete users
3. Then run truncate script again

### Accidentally Truncated Production

**Symptom:** All production data deleted

**Fix:**
1. Don't panic - check if backups exist
2. Supabase Pro plan has automatic backups
3. Contact Supabase support immediately
4. Implement rule: Never run `truncate_staging.sql` when `current = .production`

## Security Notes

- Never commit production credentials to git
- Use `.gitignore` for any production config files
- Current setup has staging credentials in code (acceptable for now)
- For production, consider environment variables or secure config

## Summary

| Aspect | Staging | Production |
|--------|---------|------------|
| Purpose | Development & Testing | Live App |
| Data | Disposable | Protected |
| Environment | `.staging` | `.production` |
| Clear Data | ✅ Anytime | ❌ Never |
| Project URL | qczbfdvlmdaflcvlkrtx.supabase.co | TBD |

---

**Last Updated:** March 29, 2026
