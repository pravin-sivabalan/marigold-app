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
    
    func testMedicationAdd() {
		let app = XCUIApplication()
		XCUIApplication().tabBars.buttons["Medication"].tap()
		app.navigationBars["Medication"].buttons["Add"].tap()
		app.alerts["Add Medication"].collectionViews.textFields["Medication Name"].typeText("Med 1")
		app.alerts["Add Medication"].buttons["Add"].tap()
		sleep(15)
		XCTAssert(true)
    }
	
	func testMedicationDelete() {
		let app = XCUIApplication()
		app.tabBars.buttons["Medication"].tap()
		app.navigationBars["Medication"].buttons["Refresh"].tap()
		sleep(15)
		let tablesQuery = app.tables
		tablesQuery.staticTexts["Med 1"].swipeLeft()
		tablesQuery.buttons["Delete"].tap()
		XCTAssert(true)
	}
}
