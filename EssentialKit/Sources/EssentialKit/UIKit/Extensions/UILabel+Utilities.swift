//
//  Created by Michele Restuccia on 5/3/21.
//

import UIKit

extension UILabel {
    
    public static func unlimitedLinesLabel() -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }
}
