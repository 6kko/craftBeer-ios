//
//  Created by Michele Restuccia on 13/3/21.
//  Suggested by [PCifani](https://github.com/theleftbit)
//

import UIKit

public protocol IntrinsicSizeCalculable {
    func heightConstrainedTo(width: CGFloat) -> CGFloat
}

public extension IntrinsicSizeCalculable where Self: UIView {
    func heightConstrainedTo(width: CGFloat) -> CGFloat {
        let estimatedSize = self.systemLayoutSizeFitting(
            CGSize(width: width, height: UIView.layoutFittingCompressedSize.height),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
        return estimatedSize.height
    }
}

public extension IntrinsicSizeCalculable where Self: UICollectionViewCell {
    func heightConstrainedTo(width: CGFloat) -> CGFloat {
        let estimatedSize = self.contentView.systemLayoutSizeFitting(
            CGSize(width: width, height: UIView.layoutFittingCompressedSize.height),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
        return estimatedSize.height
    }
}

public extension IntrinsicSizeCalculable where Self: UIViewController {
    func heightConstrainedTo(width: CGFloat) -> CGFloat {
        let estimatedSize = self.view.systemLayoutSizeFitting(
            CGSize(width: width, height: UIView.layoutFittingCompressedSize.height),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
        return estimatedSize.height
    }
}

@objc extension UINavigationController: IntrinsicSizeCalculable {
    public func heightConstrainedTo(width: CGFloat) -> CGFloat {
        guard let rootVC = self.viewControllers.first as? IntrinsicSizeCalculable else {
            fatalError()
        }
        let estimatedSize = rootVC.heightConstrainedTo(width: width)
        return estimatedSize + navigationBar.bounds.height
    }
}

