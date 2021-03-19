//
//  Created by Michele Restuccia on 7/3/21.
//

import UIKit

extension UIImage {
    
    enum CrafBeerIcon {
        case alarm
        case cart
        case home
        case like
        case settings
        case user
    }

    static func craftBeerIcon(_ icon: CrafBeerIcon) -> UIImage {
        switch icon {
        case .alarm:
            return UIImage(named: "alarm-icon")!.withRenderingMode(.alwaysOriginal)
        case .cart:
            return UIImage(named: "cart-icon")!.withRenderingMode(.alwaysOriginal)
        case .home:
            return UIImage(named: "home-icon")!.withRenderingMode(.alwaysOriginal)
        case .like:
            return UIImage(named: "like-icon")!.withRenderingMode(.alwaysOriginal)
        case .settings:
            return UIImage(named: "settings-icon")!.withRenderingMode(.alwaysOriginal)
        case .user:
            return UIImage(named: "user-icon")!.withRenderingMode(.alwaysOriginal)
        }
    }
    
    enum CrafBeerLogo {
        case topbar
    }

    static func craftBeerLogo(_ icon: CrafBeerLogo) -> UIImage {
        switch icon {
        case .topbar:
            return UIImage(named: "logo-topbar-icon")!
        }
    }
}
