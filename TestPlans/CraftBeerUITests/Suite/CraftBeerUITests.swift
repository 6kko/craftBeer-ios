//
//  Created by Michele Restuccia on 19/3/21.
//

import XCTest
import CraftBeerAccessibility

class CraftBeerUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        
        app = XCUIApplication()
        app.launchArguments.append("--uitesting")
        app.launch()
    }
    
    override func tearDown() {
        super.tearDown()
        app.terminate()
    }
    
    func test_list_and_details() throws {
        XCTAssertTrue(app.isViewControllerVisible(.beerList))
        app.navigationBars.buttons[Identifiers.Buttons.notification].tap()
        app[collectionCell: .third].tap()
        XCTAssertTrue(app.isViewControllerVisible(.beerDetails))
    }
    
    func test_settings() throws {
        XCTAssertTrue(app.isViewControllerVisible(.beerList))
        app[tabBar: .settings].tap()
        XCTAssertTrue(app.isViewControllerVisible(.settings))
        app[tableCell: .second].swipeLeft()
        app[tableCell: .second].buttons[Identifiers.Buttons.like].tap()
    }
}
