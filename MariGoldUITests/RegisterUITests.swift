//
//  RegisterUITests.swift
//  MariGoldUITests
//
//  Created by Devin Sova on 2/18/18.
//  Copyright © 2018 MariGold. All rights reserved.
//

import XCTest

class RegisterUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
		
		//Need to do this so we don't auto login
        UserDefaults.standard.removeObject(forKey: "jwt")
		
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testRegisterWithValidInput() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.

		let app = XCUIApplication()
		app.buttons["Create an Account"].tap()
		
		let firstNameTextField = app.textFields["First Name"]
		firstNameTextField.tap()
		firstNameTextField.typeText("John")
		
		let lastNameTextField = app.textFields["Last Name"]
		lastNameTextField.tap()
		lastNameTextField.typeText("Smith")
		
		let emailAddressTextField = app.textFields["Email Address"]
		emailAddressTextField.tap()
		emailAddressTextField.typeText("test@example.com")
		
		let passwordSecureTextField = app.secureTextFields["Password"]
		passwordSecureTextField.tap()
		passwordSecureTextField.typeText("password1")
		
		let confirmPasswordSecureTextField = app.secureTextFields["Confirm Password"]
		confirmPasswordSecureTextField.tap()
		confirmPasswordSecureTextField.typeText("password1")
		app.buttons["Register"].tap()
		
		//Finish test when backend communication is available.
		XCTAssert(true)
    }
    
}
