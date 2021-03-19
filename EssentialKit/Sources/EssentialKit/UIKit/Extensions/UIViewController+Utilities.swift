//
//  Created by Michele Restuccia on 7/3/21.
//

import UIKit

public extension UIViewController {
    
    func containViewController(_ vc: UIViewController) {
        addChild(vc)
        view.addAutolayoutSubview(vc.view)
        vc.view.pinToSuperview()
        vc.willMove(toParent: self)
    }
    
    func removeContainedViewController(_ vc: UIViewController) {
        vc.willMove(toParent: nil)
        vc.view.removeFromSuperview()
        vc.removeFromParent()
    }
    
    func showTodoAlert() {
        let operation = PresentAlertOperation(
            title: "To-Do", message: nil, presentingViewController: self
        )
        alertQueue.addOperation(operation)
    }
}

extension UIViewController {
    
    //Based on https://stackoverflow.com/a/28158013/1152289
    @objc public func closeViewController(sender: Any?) {
        guard let presentingVC = targetViewController(forAction: #selector(closeViewController(sender:)), sender: sender) else { return }
        presentingVC.closeViewController(sender: sender)
    }
}

public extension UINavigationController {
    
    @objc override func closeViewController(sender: Any?) {
        self.popViewController(animated: true)
    }
}

import SafariServices
public extension UIViewController {
    
    @objc func presentSafariVC(withURL url: URL) {
        let safariVC = SFSafariViewController(url: url)
        self.present(safariVC, animated: true, completion: nil)
    }
}

private let alertQueue: OperationQueue = {
    let operationQueue = OperationQueue()
    operationQueue.qualityOfService = .userInteractive
    operationQueue.maxConcurrentOperationCount = 1
    operationQueue.name = "com.essential.alertpresenting"
    return operationQueue
}()

