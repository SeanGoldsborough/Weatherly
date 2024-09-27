//
//  MainViewTest.swift
//  WeatherlyTests
//
//  Created by Sean Goldsborough on 9/27/24.
//

import XCTest
import SwiftUI
//@testable import recifear

final class MainViewTest: XCTestCase {

   private var app: XCUIApplication!
   
   override func setUpWithError() throws { //Does this each time it starts the test
        continueAfterFailure = false
        app = XCUIApplication() // Initializes the XCTest app
        app.launch() // Launches the app
   }
   
   override func tearDownWithError() throws { //Does this each time it ends the test
        app = nil //Makes sure that the test wont have residual values, it will be torn down each time the funcion has finished
   }

   func testNavigationToRecentSearchView() {
        let recentSearchButton = app.buttons["RecentSearchButton"]
        XCTAssertTrue(recentSearchButton.exists)
       recentSearchButton.tap()

        let recentSearchViewTitle = app.staticTexts["Weatherly"]
        XCTAssertTrue(recentSearchViewTitle.waitForExistence(timeout: 5))
   }

}
