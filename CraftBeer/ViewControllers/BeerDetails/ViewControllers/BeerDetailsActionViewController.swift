//
//  Created by Michele Restuccia on 13/3/21.
//

import UIKit
import EssentialKit

extension BeerDetailsViewController {
    
    class ActionViewController: UIViewController, ViewModelConfigurable {
        
        enum VM {
            case inStock, outStock
        }
        
        let actionButton = PillButton()
        
        override func loadView() {
            view = UIView()
            view.backgroundColor = UIColor.craftBeerSecondaryBackgroundColor
            actionButton.setFontStyle(.title3)
            
            let contentStackView = UIStackView(arrangedSubviews: [actionButton])
            contentStackView.arrangedSubviews.forEach{
                $0.heightAnchor.constraint(equalToConstant: Constants.ButtonHeight).isActive = true
            }
            contentStackView.isLayoutMarginsRelativeArrangement = true
            contentStackView.layoutMargins = .init(uniform: Constants.Spacing)
            contentStackView.spacing = Constants.NormalSpacing
            view.addSubview(contentStackView)
            contentStackView.pinToSuperview()
        }
        
        func configureFor(viewModel: VM) {
            let icon = viewModel.icon.scaleTo(.init(width: 20, height: 20))
            actionButton.addIcon(icon, title: viewModel.title)
        }
    }
}

private extension BeerDetailsViewController.ActionViewController.VM {
    var icon: UIImage {
        switch self {
        case .inStock: return .craftBeerIcon(.cart)
        case .outStock: return .craftBeerIcon(.alarm)
        }
    }
    
    var title: String {
        switch self {
        case .inStock: return "beer-add-cart".localized
        case .outStock: return "notify-when-available".localized
        }
    }
}
