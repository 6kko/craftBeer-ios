//
//  Created by Michele Restuccia on 13/3/21.
//

import Foundation

public func isiOSAppOnMac() -> Bool {
    ProcessInfo.processInfo.isCatalystOriIOSAppOnMac
}
