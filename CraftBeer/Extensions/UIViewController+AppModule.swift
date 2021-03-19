//
//  Created by Michele Restuccia on 17/3/21.
//

import UIKit
import EssentialKit

extension UIViewController {

    var notificationBarButtonItem: UIBarButtonItem? {
        guard let moduleVC = self as? (AppModule & UIViewController), moduleVC.shouldShowNotification else {
            return nil
        }
        return moduleVC.notificationButton()
    }
        
    @objc func onNotificationButtonTapped() {
        showTodoAlert()
        Tracking.trackEvent(.featureUsed(.pushNotification))
    }
}

private extension AppModule where Self: UIViewController {
    func notificationButton() -> UIBarButtonItem {
        let image = UIImage.craftBeerIcon(.alarm).scaleTo(.init(width: 20, height: 20))
        let button = UIBarButtonItem(
            image: image.withTintColor(.orange, renderingMode: .alwaysOriginal),
            style: .plain,
            target: self,
            action: #selector(onNotificationButtonTapped)
        )
        
        /// Setup accesibility
        button.setCraftBeerIdentifier(.notification)
        
        return button
    }
}
