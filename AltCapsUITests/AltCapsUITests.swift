//
//  AltCapsUITests.swift
//  AltCaps
//
//  Created by Mark Weller on 2/16/26.
//


import XCTest

final class AltCapsUITests: XCTestCase {

    private var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    // MARK: - Smoke Test

    func testAppLaunchesToHomeView() throws {
        // Verifies main branding and core text
        XCTAssertTrue(app.staticTexts["AltCaps Keyboard"].exists)
        XCTAssertTrue(app.staticTexts["Automatically capitalizes every other letter while keeping the first letter unchanged."].exists)
    }

    // MARK: - Navigation Tests

    func testNavigateToEnableInstructions() throws {
        let enableButton = app.buttons["How to Enable Keyboard"]
        XCTAssertTrue(enableButton.exists)
        enableButton.tap()

        XCTAssertTrue(app.staticTexts["How to Enable AltCaps Keyboard"].exists)
        XCTAssertTrue(app.staticTexts["1. Open the Settings app"].exists)
        XCTAssertTrue(app.staticTexts["5. Switch keyboards using the 🌐 globe key"].exists)
    }

    func testNavigateToKeyboardTestView() throws {
        let testKeyboardButton = app.buttons["Test Keyboard"]
        XCTAssertTrue(testKeyboardButton.exists)
        testKeyboardButton.tap()

        // Adjust this assertion if KeyboardTestView has a unique title
        XCTAssertTrue(app.navigationBars.count > 0)
    }

    func testNavigateToPrivacyView() throws {
        let privacyButton = app.buttons["Privacy & Data"]
        XCTAssertTrue(privacyButton.exists)
        privacyButton.tap()

        // Update this if your PrivacyView has a specific title label
        XCTAssertTrue(app.staticTexts["Privacy"].exists || app.staticTexts["Privacy & Data"].exists)
    }
}
