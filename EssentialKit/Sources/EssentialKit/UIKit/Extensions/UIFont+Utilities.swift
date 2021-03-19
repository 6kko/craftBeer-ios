//
//  Created by Michele Restuccia on 7/3/21.
//

import UIKit

public extension UIFont {
    
    var isBold: Bool {
        return fontDescriptor.symbolicTraits.contains(.traitBold)
    }
    
    func bolded() -> UIFont {
        return UIFont(descriptor: fontDescriptor.withSymbolicTraits(.traitBold)!, size: pointSize)
    }
}
