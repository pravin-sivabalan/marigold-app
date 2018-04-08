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
		
		let app = XCUIApplication()
		app.tabBars.buttons["Medication"].tap()
		app.navigationBars["Medication"].buttons["Add"].tap()
		app.buttons["Camera"].tap()
		addPhotoLibrary(app)
	}
}

struct Platform {
	static var isSimulator: Bool {
		return TARGET_OS_SIMULATOR != 0
	}
}


extension XCUIElement {
	func tapIfExists() {
		if exists {
			tap()
		}
	}
}

// MARK: - Helper functions
extension XCTestCase {
	func addPhotoCamera(_ app: XCUIApplication) {
		let pleaseSelectSheet = app.sheets.element
		
		//["Take Picture"].tap()
		pleaseSelectSheet.buttons.element(boundBy: 0).tap()
		
		//use coordinates and tap on Take picture button
		let element = app
			.children(matching: .window).element(boundBy: 0)
			.children(matching: .other).element
			.children(matching: .other).element
			.children(matching: .other).element
			.children(matching: .other).element
		
		let photoCapture = element.children(matching: .other).element
			.children(matching: .other).element(boundBy: 1)
			.children(matching: .other).element
		
		photoCapture.tap()
		
		sleep(5)
		
		app.buttons["Use Photo"].tap()
	}
	
	func addPhotoLibrary(_ app: XCUIApplication, index: Int = 0) {
		//let pleaseSelectSheet = app.sheets["Add Photo"]
		//pleaseSelectSheet.buttons.element(boundBy: 1).tap()
		
		sleep(10)
		
		//Camera Roll
		app.tables.cells.element(boundBy: 1).tap()
		
		sleep(2)
		
		let photoCells = app.collectionViews.cells
		if Platform.isSimulator {
			photoCells.element(boundBy: index).tap()
		} else {
			photoCells.allElementsBoundByIndex.last!.firstMatch.tap()
		}
		
		sleep(2)
		
		app.buttons["Choose"].tapIfExists()
	}
}
