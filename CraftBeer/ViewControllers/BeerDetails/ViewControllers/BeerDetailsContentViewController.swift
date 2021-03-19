//
//  Created by Michele Restuccia on 13/3/21.
//

import UIKit
import EssentialKit

extension BeerDetailsViewController {
    
    class ContentViewController: UIViewController, ViewModelConfigurable {
        
        struct VM {
            let basicInfoVM: BasicInfoView.VM
        }
        
        private let scrollableStackView = ScrollableStackView(axis: .vertical, alignment: .fill)
        private let basicInfoView = BasicInfoView()
        
        override func loadView() {
            scrollableStackView.backgroundColor = .clear
            scrollableStackView.alwaysBounceVertical = true
            scrollableStackView.layoutMargins = [
                .top: Constants.Spacing, .bottom: Constants.BigSpacing
            ]
            
            let layoutMargins: UIEdgeInsets = [.left: Constants.Spacing, .right: Constants.Spacing]
            scrollableStackView.addArrangedSubview(basicInfoView, layoutMargins: layoutMargins)
            
            view = scrollableStackView
        }
        
        func scrollToPhotoAt(index: Int) {
            basicInfoView.currentlySelectedPhotoIndex = index
        }
        
        //MARK: ViewModelConfigurable
        
        func configureFor(viewModel: VM) {
            basicInfoView.configureFor(viewModel: viewModel.basicInfoVM)
        }
    }
}
