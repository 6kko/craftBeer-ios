//
//  Created by Michele Restuccia on 13/3/21.
//

import UIKit
import EssentialKit

extension UIView {
    
    static func craftBeerLoadingView(color: UIColor = .orange) -> MaterialActivityIndicatorView {
        let loadingView = MaterialActivityIndicatorView()
        loadingView.color = color
        loadingView.startAnimating()
        return loadingView
    }
}
