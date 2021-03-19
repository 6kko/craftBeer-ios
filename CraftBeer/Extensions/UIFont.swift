//
//  Created by Michele Restuccia on 6/3/21.
//


import UIKit
import EssentialKit

let mediumTextStyler    = TextStyler(fontDescriptor: Fonts.sofiaPro.fontDescriptor(variant: .medium))
let regularTextStyler   = TextStyler(fontDescriptor: Fonts.sofiaPro.fontDescriptor(variant: .regular))
let boldTextStyler      = TextStyler(fontDescriptor: Fonts.sofiaPro.fontDescriptor(variant: .bold))

enum Fonts {
    case sofiaPro

    enum Variant {
        case regular
        case medium
        case bold
    }
    
    fileprivate func fontDescriptor(variant: Variant = .regular) -> UIFontDescriptor {
        let name: String = {
            switch variant {
            case .regular:
                return "SofiaProRegular"
            case .medium:
                return "SofiaProMedium"
            case .bold:
                return "SofiaPro-Bold"
            }
        }()
        return UIFontDescriptor(fontAttributes: [
            .name : name,
        ])
    }
}
