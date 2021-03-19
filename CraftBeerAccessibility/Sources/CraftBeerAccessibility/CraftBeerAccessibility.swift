//
//  Created by Michele Restuccia on 19/3/21.
//

import UIKit

public enum Identifiers {
    
    public enum PositionCells: Int {
        case first = 0
        case second = 1
        case third = 2
    }
    
    public enum Buttons: String {
        case notification
        case like
    }
    
    public enum ViewControllers: String {
        case beerList
        case beerDetails
        case settings
    }
    
    public enum TabBarItems: String {
        case beerList
        case settings
    }
}
