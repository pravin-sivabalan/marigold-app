//
//  MedicationUITests.swift
//  MariGoldUITests
//
//  Created by Devin Sova on 2/23/18.
//  Copyright © 2018 MariGold. All rights reserved.
//

import XCTest

class MedicationUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
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
	
    //Now Manual Testing
    //func testMedicationAdd()
	
	func testMedicationEdit() {
		
		let app = XCUIApplication()
		app.tabBars.buttons["Medication"].tap()
		app.tables/*@START_MENU_TOKEN@*/.staticTexts["Viagra"]/*[[".cells[\"Viagra\"].staticTexts[\"Viagra\"]",".staticTexts[\"Viagra\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
		app.navigationBars["Info"].buttons["Edit"].tap()
		
		let tablesQuery = app.tables
		
		let textField = tablesQuery.cells.containing(.staticText, identifier:"Quantity").children(matching: .textField).element
		textField.tap()
		textField.typeText("32")
		
		let infoNavigationBar = app.navigationBars["Info"]
		infoNavigationBar.buttons["Done"].tap()
		infoNavigationBar.buttons["Medication"].tap()
		
	}
	
	func testMedicationCameraAdd() {
		
	}
}
