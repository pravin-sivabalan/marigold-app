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
		app.tabBars.buttons["Medication"].tap()
		app.navigationBars["Medication"].buttons["Add"].tap()

		let tablesQuery = app.tables
		
		tablesQuery/*@START_MENU_TOKEN@*/.textFields["Name"]/*[[".cells.textFields[\"Name\"]",".textFields[\"Name\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
		tablesQuery.children(matching: .cell).element(boundBy: 0).children(matching: .textField).element.typeText("Test Med")
		
		tablesQuery/*@START_MENU_TOKEN@*/.textFields["Dosage"]/*[[".cells.textFields[\"Dosage\"]",".textFields[\"Dosage\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
		tablesQuery.children(matching: .cell).element(boundBy: 1).children(matching: .textField).element.typeText("20")
		
		tablesQuery/*@START_MENU_TOKEN@*/.textFields["Quantity"]/*[[".cells.textFields[\"Quantity\"]",".textFields[\"Quantity\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
		tablesQuery.children(matching: .cell).element(boundBy: 2).children(matching: .textField).element.typeText("36")
		
		tablesQuery/*@START_MENU_TOKEN@*/.textFields["Times Per Week"]/*[[".cells.textFields[\"Times Per Week\"]",".textFields[\"Times Per Week\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
		tablesQuery.children(matching: .cell).element(boundBy: 3).children(matching: .textField).element.typeText("3")
		
		app.navigationBars["Add Medication"].buttons["Done"].tap()
		
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