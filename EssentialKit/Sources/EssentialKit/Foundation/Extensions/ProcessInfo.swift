//
//  Created by Michele Restuccia on 13/3/21.
//

import Foundation

public extension ProcessInfo {
    var isCatalystOriIOSAppOnMac: Bool {
        #if targetEnvironment(macCatalyst)
        return true
        #else
        if #available(iOS 14.0, macOS 11, *) {
            return isiOSAppOnMac
        } else {
            return false
        }
        #endif
    }
}
