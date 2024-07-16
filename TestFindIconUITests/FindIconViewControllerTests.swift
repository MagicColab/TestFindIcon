//
//  IconsCollectionViewTests.swift
//  TestFindIconUITests
//
//  Created by Zaruhi Davtyan on 26.06.24.
//

import XCTest
@testable import IconFinder

final class FindIconViewControllerTests: XCTestCase {
    
    var app: XCUIApplication!

    override func setUpWithError() throws {
        app = XCUIApplication()
        app.launch()
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testAppStartsEmpty() {
        XCTAssertEqual(app.cells.count, 0, "Should be 0 cells when the app is first launched.")
    }
    
    func testSearchBarSettingSearch() throws {
        let searchField = try app.searchFields[FindIconViewController.Views.searchBar.identifier]
        XCTAssertEqual(searchField.placeholderValue, "Search Icons")
    }
}
