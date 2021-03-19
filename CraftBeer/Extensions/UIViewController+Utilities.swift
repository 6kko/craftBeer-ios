//
//  Created by Michele Restuccia on 7/3/21.
//

import UIKit
import Task

extension UIViewController {
    
    func addPlainBackButton() {
        if #available(iOS 14.0, *) {
            navigationItem.backButtonDisplayMode = .minimal
        } else {
            navigationItem.backBarButtonItem = UIBarButtonItem(title: "   ", style: .plain, target: nil, action: nil)
        }
    }
    
    func addNavbarTitleView() {
        let view = UIImageView()
        view.image = UIImage.craftBeerLogo(.topbar)
        view.frame = .init(x: 0, y: 0, width: 154, height: 34)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: view)
    }
}
