//
//  EditingViewModelTests.swift
//  VeloTests
//
//  Unit tests for EditingViewModel
//

import XCTest
@testable import Velo

@MainActor
final class EditingViewModelTests: XCTestCase {

    // MARK: - Properties

    var viewModel: EditingViewModel!

    // MARK: - Setup

    override func setUp() async throws {
        try await super.setUp()
        viewModel = EditingViewModel()
    }

    override func tearDown() async throws {
        viewModel = nil
        try await super.tearDown()
    }

    // MARK: - Initialization Tests

    func testInitialState() {
        XCTAssertNil(viewModel.currentImage)
        XCTAssertNil(viewModel.editedImage)
        XCTAssertFalse(viewModel.messages.isEmpty, "Should have initial AI message")
        XCTAssertEqual(viewModel.messageText, "")
        XCTAssertFalse(viewModel.isProcessing)
        XCTAssertFalse(viewModel.isRecording)
        XCTAssertFalse(viewModel.showBeforeAfter)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.suggestions.isEmpty, "Should have default suggestions")
    }

    func testInitWithImage() {
        let testImage = UIImage(systemName: "photo")!
        let vmWithImage = EditingViewModel(image: testImage)

        XCTAssertNotNil(vmWithImage.currentImage)
    }

    // MARK: - Message Tests

    func testSendEmptyMessageDoesNothing() async {
        viewModel.messageText = ""
        let initialMessageCount = viewModel.messages.count

        await viewModel.sendMessage()

        XCTAssertEqual(viewModel.messages.count, initialMessageCount)
    }

    func testSendMessageValidation() async {
        // Too short
        viewModel.messageText = "Hi"
        await viewModel.sendMessage()
        XCTAssertNotNil(viewModel.errorMessage)

        // Clear error
        viewModel.errorMessage = nil

        // Too long
        viewModel.messageText = String(repeating: "a", count: 600)
        await viewModel.sendMessage()
        XCTAssertNotNil(viewModel.errorMessage)
    }

    func testMessageSanitization() {
        let maliciousInput = "<script>alert('xss')</script>"
        let sanitized = maliciousInput.sanitizedForAI

        XCTAssertFalse(sanitized.contains("<"))
        XCTAssertFalse(sanitized.contains(">"))
    }

    // MARK: - Suggestion Tests

    func testSuggestionsExist() {
        XCTAssertFalse(viewModel.suggestions.isEmpty)
        XCTAssertTrue(viewModel.suggestions.count >= 4)
    }

    func testApplySuggestion() {
        guard let suggestion = viewModel.suggestions.first else {
            XCTFail("No suggestions available")
            return
        }

        // Note: This will trigger async processing
        viewModel.applySuggestion(suggestion)

        // The message text should be empty after sending
        // But we can't easily test the full flow without mocking
    }

    // MARK: - Image Action Tests

    func testResetToOriginal() {
        viewModel.editedImage = UIImage(systemName: "photo")!
        viewModel.showBeforeAfter = true

        viewModel.resetToOriginal()

        XCTAssertNil(viewModel.editedImage)
        XCTAssertFalse(viewModel.showBeforeAfter)
    }

    func testSaveWithNoImage() {
        viewModel.editedImage = nil

        viewModel.saveEditedImage()

        XCTAssertNotNil(viewModel.errorMessage)
    }
}

// MARK: - String Validation Tests

final class StringValidationTests: XCTestCase {

    func testValidEditCommand() {
        XCTAssertTrue("Make it brighter".isValidEditCommand)
        XCTAssertTrue("Remove the background please".isValidEditCommand)
        XCTAssertTrue("Fix".isValidEditCommand) // Minimum 3 chars
    }

    func testInvalidEditCommand() {
        XCTAssertFalse("".isValidEditCommand)
        XCTAssertFalse("Hi".isValidEditCommand) // Too short
        XCTAssertFalse("   ".isValidEditCommand) // Whitespace only
        XCTAssertFalse(String(repeating: "a", count: 501).isValidEditCommand) // Too long
    }

    func testSanitization() {
        XCTAssertEqual("Hello World".sanitizedForAI, "Hello World")
        XCTAssertEqual("<script>alert()</script>".sanitizedForAI, "scriptalert()/script")
        XCTAssertEqual("{malicious: 'code'}".sanitizedForAI, "malicious: 'code'")
    }
}

// MARK: - UserProfile Tests

final class UserProfileTests: XCTestCase {

    func testFreeUserHasEditLimit() {
        let profile = UserProfile(
            id: "test",
            roleType: .explorer,
            subscriptionTier: .free,
            editsThisMonth: 0,
            editsMonthStart: Date(),
            createdAt: Date()
        )

        XCTAssertEqual(profile.editsRemaining, 5)
        XCTAssertTrue(profile.hasEditsRemaining)
    }

    func testFreeUserExceedsLimit() {
        let profile = UserProfile(
            id: "test",
            roleType: .explorer,
            subscriptionTier: .free,
            editsThisMonth: 5,
            editsMonthStart: Date(),
            createdAt: Date()
        )

        XCTAssertEqual(profile.editsRemaining, 0)
        XCTAssertFalse(profile.hasEditsRemaining)
    }

    func testProUserUnlimited() {
        let profile = UserProfile(
            id: "test",
            roleType: .salon,
            subscriptionTier: .pro,
            editsThisMonth: 100,
            editsMonthStart: Date(),
            createdAt: Date()
        )

        XCTAssertNil(profile.editsRemaining)
        XCTAssertTrue(profile.hasEditsRemaining)
    }

    func testMonthlyReset() {
        let lastMonth = Calendar.current.date(byAdding: .month, value: -1, to: Date())!
        let profile = UserProfile(
            id: "test",
            roleType: .explorer,
            subscriptionTier: .free,
            editsThisMonth: 5,
            editsMonthStart: lastMonth,
            createdAt: Date()
        )

        XCTAssertTrue(profile.needsMonthlyReset)
    }
}

// MARK: - RoleType Tests

final class RoleTypeTests: XCTestCase {

    func testAllRolesHaveGradient() {
        for role in RoleType.allCases {
            XCTAssertFalse(role.gradient.isEmpty, "\(role) should have gradient colors")
        }
    }

    func testAllRolesHaveFeatures() {
        for role in RoleType.allCases {
            XCTAssertFalse(role.features.isEmpty, "\(role) should have features")
        }
    }

    func testRoleDisplayNames() {
        XCTAssertEqual(RoleType.parent.displayName, "Everyday User")
        XCTAssertEqual(RoleType.salon.displayName, "Salon/Beauty Owner")
        XCTAssertEqual(RoleType.realtor.displayName, "Real Estate Pro")
        XCTAssertEqual(RoleType.business.displayName, "Small Business")
        XCTAssertEqual(RoleType.explorer.displayName, "Just Exploring")
    }
}
