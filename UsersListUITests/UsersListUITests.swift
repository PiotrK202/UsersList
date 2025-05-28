//
//  UsersListUITests.swift
//  UsersListUITests
//
//  Created by piotr koscielny on 26/5/25.
//

import XCTest
@testable import UsersList

@MainActor
final class UsersListUITests: XCTestCase {
    override func setUpWithError() throws {
        continueAfterFailure = false
    }
    
    override func tearDownWithError() throws { }
    
    func testUserFlow() throws {
        let app = XCUIApplication()
        app.launch()
        app.launchArguments.append("--uitest")
        
        let usersList = app.collectionViews.firstMatch
        XCTAssertTrue(usersList.waitForExistence(timeout: 3))
        
        let firstUser =  usersList.cells.element(boundBy: 0)
        XCTAssertTrue(firstUser.exists)
        firstUser.tap()
        
        let detailView = app.scrollViews[AccessibilityIdentifiers.UserDetailView.userDetailView]
        XCTAssertTrue(detailView.waitForExistence(timeout: 2))
        
        let nameField = app.textFields[AccessibilityIdentifiers.UserDetailView.userNameTextField]
        let jobField = app.textFields[AccessibilityIdentifiers.UserDetailView.userJobTextField]
        let updatedButton = app.buttons[AccessibilityIdentifiers.UserDetailView.updateUserButton]
        
        nameField.tap()
        nameField.typeText("new name")
        
        jobField.tap()
        jobField.typeText("new job")
        
        updatedButton.tap()
        
        app.navigationBars.buttons.element(boundBy: 0).tap()
        
        app.navigationBars.buttons["Add"].tap()
        
        let addView = app.otherElements[AccessibilityIdentifiers.UserAddView.addUserView]
        XCTAssertTrue(addView.waitForExistence(timeout: 2))
        
        let newNameField = app.textFields[AccessibilityIdentifiers.UserAddView.userNameTextField]
        let newJobField = app.textFields[AccessibilityIdentifiers.UserAddView.userJobTextField]
        let creatButton = app.buttons[AccessibilityIdentifiers.UserAddView.addUserButton]
        
        newNameField.tap()
        newNameField.typeText("new user")
        
        newJobField.tap()
        newJobField.typeText("new job")
        
        creatButton.tap()
        XCTAssertTrue(usersList.waitForExistence(timeout: 2))
    }
    
    func testLaunchPerformance() throws {
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }
}
