//
//  Created by Michele Restuccia on 12/3/21.
//

import UIKit

public extension UIImage {
    
    enum Template: String {
        case plusRound = "plus.circle"
        case cancelRound = "xmark.circle"
        case close = "xmark"
        case camera = "camera"
        case rectangle = "rectangle.fill"
        case checkmark = "checkmark"
    }
    
    static func templateImage(_ template: Template) -> UIImage {
        if #available(iOS 13.0, tvOS 13.0, *) {
            return UIImage.interfaceKitImageNamed(template.rawValue)!
        } else {
            return UIImage()
        }
    }
    
    private class func interfaceKitImageNamed(_ name: String, compatibleWithTraitCollection: UITraitCollection? = nil) -> UIImage? {
        return UIImage(systemName: name, compatibleWith: compatibleWithTraitCollection)
    }
    
    func scaleTo(_ newSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage ?? self
    }
}
