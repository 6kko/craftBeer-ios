//
//  Created by Michele Restuccia on 5/3/21.
//

import Foundation

public extension String {
    var localized: String {
        return NSLocalizedString(self, bundle: Bundle.main, comment: "")
    }
}
