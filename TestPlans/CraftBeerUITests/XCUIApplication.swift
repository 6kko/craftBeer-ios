//
//  Created by Michele Restuccia on 19/3/21.
//

import XCTest
import CraftBeerAccessibility

public extension XCUIElementQuery {
    
    subscript<T: RawRepresentable>(key: T) -> XCUIElement where T.RawValue == String {
        return self[key.rawValue]
    }
}

public extension XCUIApplication {
    
    subscript(collectionCell key: Identifiers.PositionCells) -> XCUIElement {
        return collectionViews.cells.element(boundBy:(key.rawValue))
    }
    
    subscript(tableCell key: Identifiers.PositionCells) -> XCUIElement {
        return tables.cells.element(boundBy:(key.rawValue))
    }
    
    subscript(button key: Identifiers.Buttons) -> XCUIElement {
        return buttons[key.rawValue]
    }
    
    subscript(tabBar key: Identifiers.TabBarItems) -> XCUIElement {
        return tabBars.buttons[key.rawValue]
    }
    
    subscript(viewController key: Identifiers.ViewControllers) -> XCUIElement {
        return otherElements[key.rawValue]
    }
    
    func isViewControllerVisible(_ vc: Identifiers.ViewControllers) -> Bool {
        return otherElements[vc.rawValue].waitForExistence(timeout: 3)
    }
}
