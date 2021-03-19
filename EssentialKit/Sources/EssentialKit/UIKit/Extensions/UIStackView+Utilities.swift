//
//  Created by Michele Restuccia on 5/3/21.
//

import UIKit

public extension UIStackView {
    
    func removeAllArrangedSubviews() {
        arrangedSubviews.forEach {
            self.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
    }
    
    func addArrangedSubview(_ subview: UIView, layoutMargins: UIEdgeInsets) {
        let dummyView = StackSpacingView(subview: subview, layoutMargins: layoutMargins)
        addArrangedSubview(dummyView)
    }
}

private extension UIStackView {
    
    class StackSpacingView: UIView {
        
        var hiddenObserver: NSKeyValueObservation!
        
        init(subview: UIView, layoutMargins: UIEdgeInsets) {
            super.init(frame: .zero)
            translatesAutoresizingMaskIntoConstraints = false
            self.layoutMargins = layoutMargins
            addAutolayoutSubview(subview)
            
            //If the subview will be used for text layout, use readableContentGuide instead
            let layoutGuide: UILayoutGuide = layoutMarginsGuide
            NSLayoutConstraint.activate([
                subview.topAnchor.constraint(equalTo: layoutGuide.topAnchor),
                subview.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor),
                subview.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor),
                subview.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor),
            ])
            
            hiddenObserver = subview.observe(\.isHidden, changeHandler: { [weak self] (view, _) in
                self?.isHidden = view.isHidden
            })
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}
