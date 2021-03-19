//
//  Created by Michele Restuccia on 13/3/21.
//

import UIKit
import EssentialKit

class PillButton: UIButton {
    
    static let RadiusButton: CGFloat = 4
    
    let mainColor: UIColor
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var activityIndicatorView: UIView?

    private enum Constants {
        static let TitleAdjustments: UIEdgeInsets = [.bottom: -3]
    }
    
    init(mainColor: UIColor = .orange, inset: UIEdgeInsets = UIEdgeInsets(uniform: 16)) {
        self.mainColor = mainColor
        super.init(frame: .zero)
        setFontStyle(.headline)
        adjustsImageWhenHighlighted = false
        backgroundColor = mainColor
        titleEdgeInsets = Constants.TitleAdjustments
        contentEdgeInsets = inset
        self.isPointerInteractionEnabled = true
        titleLabel?.numberOfLines = 0
        roundCorners(radius: PillButton.RadiusButton)
    }
    
    func setFontStyle(_ style: UIFont.TextStyle) {
        titleLabel?.font = boldTextStyler.fontForStyle(style)
    }

    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                backgroundColor = mainColor.darker()
            } else {
                backgroundColor = mainColor
            }
        }
    }
    
    override var isEnabled: Bool {
        didSet {
            if isEnabled {
                backgroundColor = mainColor
            } else {
                backgroundColor = .brownGreyThree
            }
        }
    }
    
    func addIcon(_ image: UIImage, title: String, shouldShowWhiteTint:Bool = true) {
        setTitle(title, for: .normal)
        setImage(image.withRenderingMode(.alwaysTemplate), for: .normal)
        if shouldShowWhiteTint {
            tintColor = .white
        }
        let spacing: CGFloat = 4
        imageEdgeInsets = UIEdgeInsets(top: -spacing, left: -spacing, bottom: -spacing, right: spacing)
        titleEdgeInsets = Constants.TitleAdjustments.adding(left: spacing, right: -spacing)
    }

    func removeIcon() {
        setImage(nil, for: .normal)
        imageEdgeInsets = .zero
        titleEdgeInsets = Constants.TitleAdjustments
    }

    func addLoadingIndicator() {
        removeLoadingIndicator()
        imageView?.alpha = 0
        titleLabel?.alpha = 0
        isUserInteractionEnabled = false
        
        activityIndicatorView = {
            let v = UIView.craftBeerLoadingView(color: .white)
            let containerView = UIView()
            containerView.roundCorners(radius: PillButton.RadiusButton)
            containerView.backgroundColor = .orange
            containerView.addAutolayoutSubview(v)
            v.heightAnchor.constraint(equalToConstant: 20).isActive = true
            v.widthAnchor.constraint(equalToConstant: 20).isActive = true
            v.centerInSuperview()
            return containerView
        }()
        addAutolayoutSubview(activityIndicatorView!)
        activityIndicatorView!.pinToSuperview()
    }
    
    func removeLoadingIndicator() {
        guard activityIndicatorView != nil else { return }
        isUserInteractionEnabled = true
        imageView?.alpha = 1
        titleLabel?.alpha = 1
        activityIndicatorView?.removeFromSuperview()
        activityIndicatorView = nil
    }
}
