-- ========================================
-- Truncate All Tables for Staging/Testing
-- ========================================
-- Run this script to clean all data before testing
-- WARNING: This will delete ALL data in the database!

-- Truncate tables in correct order (respecting foreign keys)
TRUNCATE TABLE chat_messages CASCADE;
TRUNCATE TABLE receipts CASCADE;
TRUNCATE TABLE subscriptions CASCADE;
TRUNCATE TABLE companies CASCADE;
TRUNCATE TABLE user_profiles CASCADE;

-- Delete all auth users (this triggers deletion of user_profiles)
DELETE FROM auth.users;

-- Verify all tables are empty
SELECT 'chat_messages' as table_name, COUNT(*) as row_count FROM chat_messages
UNION ALL
SELECT 'receipts', COUNT(*) FROM receipts
UNION ALL
SELECT 'subscriptions', COUNT(*) FROM subscriptions
UNION ALL
SELECT 'companies', COUNT(*) FROM companies
UNION ALL
SELECT 'user_profiles', COUNT(*) FROM user_profiles
UNION ALL
SELECT 'auth.users', COUNT(*) FROM auth.users;
