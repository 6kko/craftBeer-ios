//
//  Created by Michele Restuccia on 5/3/21.
//

import UIKit

public extension UIApplication {
    
    var currentWindow: UIWindow {
        let keyWindow = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows
            .filter({$0.isKeyWindow}).first
        return keyWindow!
    }
    
    var isRunningTests: Bool {
        #if DEBUG
        return NSClassFromString("XCTest") != nil
        #else
        return false
        #endif
    }
}
