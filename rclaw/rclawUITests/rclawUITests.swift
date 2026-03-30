//
//  rclawUITests.swift
//  rclawUITests
//
//  Automated UI tests for rclaw expense tracking app
//

import XCTest

final class rclawUITests: XCTestCase {

    var app: XCUIApplication!

    // Track last signup time to avoid rate limiting (Supabase: 3 seconds between signups)
    static var lastSignupTime: Date?
    static let signupRateLimitSeconds: TimeInterval = 4.0

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        app.terminate()
    }

    // Helper: Wait for rate limit before attempting signup
    func waitForRateLimit() {
        if let lastTime = Self.lastSignupTime {
            let elapsed = Date().timeIntervalSince(lastTime)
            let remaining = Self.signupRateLimitSeconds - elapsed
            if remaining > 0 {
                print("⏱ Waiting \(remaining)s for rate limit...")
                sleep(UInt32(ceil(remaining)))
            }
        } else {
            // First signup in test suite - wait extra time for any previous test runs
            print("⏱ First signup - waiting 5s for rate limit reset...")
            sleep(5)
        }
        Self.lastSignupTime = Date()
    }

    // MARK: - Test Cases

    /// Test 1: App launches successfully and shows login screen
    func testAppLaunches() throws {
        // Verify login screen elements are visible
        XCTAssertTrue(app.staticTexts["Receipt Claw"].exists, "Login screen should show app title")
        XCTAssertTrue(app.buttons["Sign Up"].exists, "Sign up button should be visible")
        XCTAssertTrue(app.staticTexts["Welcome back"].exists, "Login screen should show welcome message")
    }

    /// Test 2: Complete signup flow
    func testSignupFlow() throws {
        // Wait for rate limit before attempting signup
        waitForRateLimit()

        // Test email: Use timestamp to ensure uniqueness
        let timestamp = Int(Date().timeIntervalSince1970)
        let testEmail = "test\(timestamp)@example.com"
        let testPassword = "TestPass123!"
        let testName = "Test User"

        // Tap Sign Up button to switch to signup mode
        app.buttons["Sign Up"].tap()

        // Wait for signup form to appear
        sleep(1)

        // Fill in Full Name (appears first in signup form)
        let nameField = app.textFields["John Doe"]
        XCTAssertTrue(nameField.waitForExistence(timeout: 2), "Full name field should appear")
        nameField.tap()
        nameField.typeText(testName)

        // Fill in Email
        let emailField = app.textFields["you@example.com"]
        emailField.tap()
        emailField.typeText(testEmail)

        // Fill in Password
        let passwordField = app.secureTextFields["Enter your password"]
        passwordField.tap()
        passwordField.typeText(testPassword)

        // Tap Create Account button
        let createAccountButton = app.buttons["Create Account"]
        XCTAssertTrue(createAccountButton.exists, "Create Account button should exist")
        createAccountButton.tap()

        // Wait a moment for processing
        sleep(2)

        // Check if error alert appeared
        if app.alerts.element.exists {
            let alertMessage = app.alerts.element.staticTexts.element(boundBy: 1).label
            XCTFail("Signup failed with error: \(alertMessage)")
        }

        // Wait for company onboarding screen (indicates successful signup)
        let companySetupTitle = app.staticTexts["Set Up Your Company"]
        XCTAssertTrue(companySetupTitle.waitForExistence(timeout: 15),
                     "Should navigate to company onboarding after signup")
    }

    /// Test 3: Complete company creation flow
    func testCompanyCreationFlow() throws {
        // First complete signup
        try testSignupFlow()

        // Now on company onboarding screen - fill in company details
        let companyNameField = app.textFields["Acme Inc."]
        XCTAssertTrue(companyNameField.exists, "Company name field should exist")
        companyNameField.tap()
        companyNameField.typeText("Test Company LLC")

        let addressField = app.textFields["123 Main St, City, State ZIP"]
        addressField.tap()
        addressField.typeText("456 Business Ave, San Francisco, CA 94105")

        let taxIdField = app.textFields["12-3456789"]
        taxIdField.tap()
        taxIdField.typeText("98-7654321")

        // Submit company creation
        app.buttons["Create Company"].tap()

        // Wait for main app screen (RClaw chat view)
        let navTitle = app.navigationBars["RClaw"]
        XCTAssertTrue(navTitle.waitForExistence(timeout: 10),
                     "Should navigate to main app after company creation")
    }

    /// Test 4: Navigation to different screens
    func testNavigation() throws {
        // Complete full onboarding first
        try testCompanyCreationFlow()

        // Now we should be on the main chat screen (RClaw)
        // Verify we can see the menu button
        let menuButton = app.buttons["ellipsis.circle"]
        XCTAssertTrue(menuButton.exists, "Menu button should be visible")

        // Open menu
        menuButton.tap()
        sleep(1)

        // Check that menu items exist
        XCTAssertTrue(app.buttons["All Receipts"].exists, "All Receipts menu item should exist")
        XCTAssertTrue(app.buttons["Subscriptions"].exists, "Subscriptions menu item should exist")
        XCTAssertTrue(app.buttons["Sign Out"].exists, "Sign Out menu item should exist")

        // Tap outside to close menu
        app.coordinate(withNormalizedOffset: CGVector(dx: 0.1, dy: 0.1)).tap()
    }

    /// Test 5: Verify empty state messaging
    func testEmptyStates() throws {
        try testCompanyCreationFlow()

        // Verify welcome message appears when no receipts exist
        let welcomeText = app.staticTexts["Welcome to RClaw"]
        XCTAssertTrue(welcomeText.exists, "Should show welcome message when no receipts exist")

        // Verify feature descriptions are shown
        XCTAssertTrue(app.staticTexts.containing(NSPredicate(format: "label CONTAINS 'Upload or take a photo'")).firstMatch.exists,
                     "Should show feature description")
    }

    /// Test 6: Accessibility - VoiceOver labels
    func testAccessibility() throws {
        // Verify key UI elements have accessibility labels on login screen
        XCTAssertNotNil(app.buttons["Sign Up"].label, "Sign Up button should have label")
        XCTAssertTrue(app.staticTexts["Receipt Claw"].exists, "App title should be accessible")

        // Switch to signup mode
        app.buttons["Sign Up"].tap()
        sleep(1)

        // Check if text fields have proper accessibility
        let emailField = app.textFields["you@example.com"]
        XCTAssertTrue(emailField.exists, "Email field should be accessible")
    }

    // MARK: - Performance Tests

    /// Test 7: App launch performance
    func testLaunchPerformance() throws {
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }

    /// Test 8: Screen transition performance
    func testNavigationPerformance() throws {
        measure {
            // Measure the time to switch to signup mode
            app.buttons["Sign Up"].tap()
            // Wait for signup form to appear
            _ = app.textFields["John Doe"].waitForExistence(timeout: 5)
            // Switch back to sign in
            app.buttons["Sign In"].tap()
            // Wait for sign in mode
            sleep(1)
        }
    }
}
