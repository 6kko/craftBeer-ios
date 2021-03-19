//
//  Created by Michele Restuccia on 6/3/21.
//

import UIKit
import EssentialKit

extension UIColor {
    
    static let craftBeerTintColor: UIColor = {
        return craftBeerTextTitleColor
    }()
    
    static let craftBeerTextTitleColor: UIColor = {
        if #available(iOS 13.0, *) {
            return .label
        } else {
            return .black
        }
    }()
    
    static let craftBeerSecondaryTextColor: UIColor = {
        let lightColor = UIColor(red: 74/255, green: 74/255, blue: 74/255, alpha: 1)
        if #available(iOS 13.0, *) {
            return UIColor(light: lightColor, dark: .secondaryLabel)
        } else {
            return lightColor
        }
    }()
    
    static let craftBeerBackgroundColor: UIColor = {
        let lightColor = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1.0)
        if #available(iOS 13.0, *) {
            return UIColor(light: lightColor, dark: .systemBackground)
        } else {
            return lightColor
        }
    }()
    
    static let craftBeerSecondaryBackgroundColor: UIColor = {
        let lightColor = UIColor.white
        if #available(iOS 13.0, *) {
            return UIColor(light: lightColor, dark: .secondarySystemBackground)
        } else {
            return .white
        }
    }()
    
    static let craftBeerTertiaryBackgroundColor: UIColor = {
        let lightColor = UIColor(red: 237/255, green: 237/255, blue: 237/255, alpha: 1.0)
        if #available(iOS 13.0, *) {
            return UIColor(light: lightColor, dark: .tertiarySystemBackground)
        } else {
            return lightColor
        }
    }()
    
    static let craftBeerPresentationBackgroundColor: UIColor = {
        return UIColor(red: 78/255, green: 78/255, blue: 78/255, alpha: 0.35)
    }()
}

@nonobjc extension UIColor {
    
    class var orange: UIColor {
        return UIColor(red: 245.0 / 255.0, green: 191.0 / 255.0, blue: 96.0 / 255.0, alpha: 1.0)
    }
    
    class var brownGreyThree: UIColor {
        return UIColor(white: 128.0 / 255.0, alpha: 1.0)
    }
    
    class var whiteSmoke: UIColor {
        return .init(light: UIColor(red: 244 / 255.0, green: 244 / 255.0, blue: 244 / 255.0, alpha: 1), dark: UIColor(red: 80 / 255.0, green: 80 / 255.0, blue: 80 / 255.0, alpha: 1))
    }
}

extension UIColor {
    
    func lighter(by percentage: CGFloat = 30.0) -> UIColor? {
        return self.adjust(by: abs(percentage) )
    }
    
    func darker(by percentage: CGFloat = 30.0) -> UIColor? {
        return self.adjust(by: -1 * abs(percentage) )
    }
    
    func adjust(by percentage: CGFloat = 30.0) -> UIColor? {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        if self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            return UIColor(red: min(red + percentage/100, 1.0),
                           green: min(green + percentage/100, 1.0),
                           blue: min(blue + percentage/100, 1.0),
                           alpha: alpha)
        } else {
            return nil
        }
    }
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}
