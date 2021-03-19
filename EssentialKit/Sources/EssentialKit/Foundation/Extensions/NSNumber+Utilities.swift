//
//  Created by Michele Restuccia on 5/3/21.
//

import Foundation

extension NSNumber {
    var isBool: Bool { return CFBooleanGetTypeID() == CFGetTypeID(self) }
}
