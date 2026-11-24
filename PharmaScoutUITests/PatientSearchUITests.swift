//
//  PatientSearchUITests.swift
//  PharmaScoutUITests
//
//  Created by Mohammed on 11/24/26.
//

import XCTest

final class PatientSearchUITests: XCTestCase {
    private let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
    }
    
    override func tearDownWithError() throws {
        
    }
    
    func testSearchScreenDisplaysChooseButtonWhenNoSelectedDrugs() {
        launchAndOpenSearchTab()
        
        XCTAssertTrue(app.buttons["chooseMedicineButton"].exists)
    }
    
    func testPatientCanChooseMedicineBySelectingGenericNameAndFormulation() {
        launchAndOpenSearchTab()
        
        openDrugSearchFromEmptyState()
        selectDrug("para", genericName: "Paracetamol", strength: "500 MG")
        
        XCTAssert(app.staticTexts["MEDICINE · 1"].exists)
        XCTAssert(app.buttons["startSearchButton"].exists)
    }
    
    func testTappingTrashButtonRemovesSelectedDrug() {
        launchAndOpenSearchTab()
        
        openDrugSearchFromEmptyState()
        selectDrug("para", genericName: "Paracetamol", strength: "500 MG")
        app.buttons["trash"].tap()
        
        XCTAssertFalse(app.staticTexts["MEDICINE · 1"].exists)
        XCTAssertTrue(app.buttons["chooseMedicineButton"].exists)
    }
    
    func testPatientCanChooseMultipleMedicines() {
        launchAndOpenSearchTab()
        
        openDrugSearchFromEmptyState()
        selectDrug("para", genericName: "Paracetamol", strength: "500 MG")
        openDrugSearchFromList()
        selectDrug("ibuprofen", genericName: "Ibuprofen", strength: "200 MG")
        
        XCTAssert(app.staticTexts["MEDICINE · 2"].exists)
        XCTAssert(app.buttons["startSearchButton"].exists)
    }
    
    func testPatientCanEditSelectedMedicine() {
        launchAndOpenSearchTab()
        
        openDrugSearchFromEmptyState()
        selectDrug("para", genericName: "Paracetamol", strength: "500 MG")
        
        app.staticTexts["Paracetamol"].tap()
        app.buttons["cancelParacetamolChip"].tap()
        app.buttons["searchTextField"].tap()
        selectDrug("ibuprofen", genericName: "Ibuprofen", strength: "400 MG")
        
        XCTAssert(app.staticTexts["MEDICINE · 1"].exists)
        XCTAssert(app.staticTexts["Ibuprofen"].exists)
    }
    
    func testPatientCanNotExceedDrugsCountForOneRequest() {
        launchAndOpenSearchTab()
        
        openDrugSearchFromEmptyState()
        selectDrug("para", genericName: "Paracetamol", strength: "500 MG")
        openDrugSearchFromList()
        selectDrug("ibuprofen", genericName: "Ibuprofen", strength: "200 MG")
        openDrugSearchFromList()
        selectDrug("amox", genericName: "Amoxicillin", strength: "250 MG")
        
        XCTAssert(app.staticTexts["MEDICINE · 3"].exists)
        XCTAssert(app.staticTexts["Paracetamol"].exists)
        XCTAssert(app.staticTexts["Ibuprofen"].exists)
        XCTAssert(app.staticTexts["Amoxicillin"].exists)
        XCTAssertFalse(app.buttons["addButton"].isEnabled)
    }
    
    func testPatientCanStartSearchRequestAfterChoosingDrug() {
        launchAndOpenSearchTab()
        
        openDrugSearchFromEmptyState()
        selectDrug("para", genericName: "Paracetamol", strength: "500 MG")
        app.buttons["startSearchButton"].tap()
        
        XCTAssert(app.staticTexts["Search started"].exists)
        XCTAssert(app.staticTexts["Paracetamol"].exists)
        XCTAssert(app.buttons["viewSearchButton"].exists)
    }
    
    func testPatientCanNotCreateRequestWhenLimitReached() {
        launchAndOpenSearchTab()
        let startSearchButton = app.buttons["startSearchButton"]
        
        openDrugSearchFromEmptyState()
        selectDrug("para", genericName: "Paracetamol", strength: "500 MG")
        startSearchButton.tap()
        
        app.buttons["backButton"].tap()
        openDrugSearchFromEmptyState()
        selectDrug("ibuprofen", genericName: "Ibuprofen", strength: "200 MG")
        startSearchButton.tap()	
        app.buttons["backButton"].tap()
        
        XCTAssert(app.staticTexts["Search limit reached"].exists)
    }
    
    private func launchAndOpenSearchTab() {
        app.launchArguments = ["-UITestMode"]
        app.launch()
        app.tabBars.buttons["Search"].tap()
    }
    
    func openDrugSearchFromEmptyState() {
        app.buttons["chooseMedicineButton"].tap()
    }
    
    func openDrugSearchFromList() {
        app.buttons["addButton"].tap()
    }
    
    private func selectDrug(_ query: String, genericName: String, strength: String) {
        app.textFields["searchTextField"].typeText(query)
        app.buttons[genericName].tap()
        app.staticTexts[strength].tap()
        app.buttons["applyMedicineChangesButton"].tap()
    }
}


private extension XCUIElement {
    func tapWhenReady(timeout: TimeInterval = 5, file: StaticString = #filePath, line: UInt = #line) {
        XCTAssertTrue(waitForExistence(timeout: timeout), "\(self) never appeared", file: file, line: line)
        tap()
    }
}
