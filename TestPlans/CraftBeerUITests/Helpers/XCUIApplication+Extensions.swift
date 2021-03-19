//
//  Created by Michele Restuccia on 19/3/21.
//

import XCTest
import CraftBeerAccessibility

extension XCUIApplication {
    var backButton: XCUIElement {
        navigationBars.buttons.element(boundBy: 0)
    }
    
    var toolbarsDoneButton: XCUIElement {
        toolbars.buttons["Done"]
    }
    
    var isTableFull: Bool {
        tables.cells.firstMatch.isHittable
    }
    
    var isTableEmpty: Bool {
        !isTableFull
    }
}
