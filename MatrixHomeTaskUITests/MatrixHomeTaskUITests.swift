//
//  MatrixHomeTaskUITests.swift
//  MatrixHomeTaskUITests
//
//  Created by hyperactive hi-tech ltd on 11/08/2021.
//  Copyright © 2021 hyperactive. All rights reserved.
//

import XCTest

class MatrixHomeTaskUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testExample() throws {
        
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launchArguments = ["enable-testing"]
        app.launch()
        
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        try testButtons(app) // works fine
        try testCollectionView(app) // works fine
        try testCollectionViewCell(app)
    }
    
    private func testCollectionViewCell(_ app: XCUIApplication) throws {
        let tableView = app.tables["MainTableView"]
        let cell = tableView.cells["\(0)"]
        let collectionView = cell.collectionViews["\(0)"]
        
        collectionView.tap()
    }
    
    private func testCollectionView(_ app: XCUIApplication) throws {
        
        // MARK: CHANGE HERE TO TEST VARIOUS TABS !
        // app.buttons["\(2)"].tap()
        
        let tableView = app.tables["MainTableView"]
        let cell = tableView.cells["\(0)"]
        let collectionView = cell.collectionViews["\(0)"]
        
        var i = 0
        
        while i < 3 {
            collectionView.swipeLeft()
            i += 1
        }
        
        while i > 0 {
            collectionView.swipeRight()
            i -= 1
        }
    }
    
    private func testButtons(_ app: XCUIApplication) throws {
        for i in 0...3 {
            app.buttons["\(i)"].tap()
        }
    }
    
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
                XCUIApplication().launch()
            }
        }
    }
}
