//
//  Created by Michele Restuccia on 14/3/21.
//

import UIKit
import EssentialKit

extension SettingsViewController {
    
    class Cell: UITableViewCell, ViewModelReusable {
        
        private let titleLabel = UILabel()
        
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            accessoryType = .disclosureIndicator
            
            let contentStackView = UIStackView(arrangedSubviews: [titleLabel])
            contentStackView.isLayoutMarginsRelativeArrangement = true
            contentStackView.layoutMargins = .init(uniform: Constants.Spacing)
            
            contentView.addAutolayoutSubview(contentStackView)
            contentStackView.pinToSuperview()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func configureFor(viewModel: String) {
            titleLabel.attributedText = regularTextStyler.attributedString(viewModel, color: .craftBeerTintColor, forStyle: .footnote)
        }
    }
}
