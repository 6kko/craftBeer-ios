//
//  Created by Michele Restuccia on 6/3/21.
//

import UIKit
import EssentialKit

extension BeerListViewController.CollectionView {
    
    private typealias Constants = BeerListViewController.Constants
    
    //MARK: BannerCell

    class BannerCell: UICollectionViewCell, ViewModelReusable {
        
        private let imageView = UIImageView()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            contentView.backgroundColor = .craftBeerBackgroundColor
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            
            contentView.addAutolayoutSubview(imageView)
            imageView.pinToSuperview()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func configureFor(viewModel: Photo) {
            imageView.setPhoto(viewModel)
        }
    }
    
    //MARK: FeatureCell
    
    class FeatureCell: UICollectionViewCell, ViewModelReusable {
        
        struct VM {
            let title: String
            let photo: Photo
        }
        
        private let titleLabel = UILabel()
        private let imageView = UIImageView()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            contentView.backgroundColor = .craftBeerBackgroundColor
            contentView.layer.borderWidth = 1
            contentView.layer.borderColor =
                UIColor(light: UIColor.brownGreyThree, dark: UIColor.orange).cgColor
            contentView.roundCorners(radius: PillButton.RadiusButton)
            
            imageView.contentMode = .scaleToFill
            imageView.clipsToBounds = true
            
            let roundView = RoundView()
            roundView.addAutolayoutSubview(imageView)
            imageView.pinToSuperview()
            
            contentView.addAutolayoutSubview(roundView)
            contentView.addAutolayoutSubview(titleLabel)
            
            NSLayoutConstraint.activate([
                roundView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.Spacing),
                roundView.centerYAnchor.constraint(equalTo: centerYAnchor),
                roundView.widthAnchor.constraint(equalToConstant: 44),
                roundView.heightAnchor.constraint(equalToConstant: 44),
                titleLabel.leadingAnchor.constraint(equalTo: roundView.trailingAnchor, constant: Constants.Spacing),
                titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.Spacing),
                titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func configureFor(viewModel: VM) {
            imageView.setPhoto(viewModel.photo)
            titleLabel.attributedText = mediumTextStyler
                .attributedString(viewModel.title, color: .craftBeerTextTitleColor, forStyle: .headline)
        }
    }
    
    //MARK: BlockCell
    
    class BlockCell: UICollectionViewCell, ViewModelReusable {
        
        struct VM {
            let ID: Int
            let title: String
            let photo: Photo
        }
        
        private let imageView = UIImageView()
        private let titleLabel = UILabel.unlimitedLinesLabel()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            contentView.backgroundColor = .craftBeerBackgroundColor
            imageView.contentMode = .scaleAspectFit
            imageView.clipsToBounds = true
            
            contentView.addAutolayoutSubview(imageView)
            contentView.addAutolayoutSubview(titleLabel)
            
            NSLayoutConstraint.activate([
                imageView.topAnchor.constraint(equalTo: topAnchor),
                imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
                imageView.widthAnchor.constraint(equalToConstant: 44),
                imageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8),
                titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: Constants.NormalSpacing),
                titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.SmallSpacing),
                titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: Constants.SmallSpacing),
            ])
            
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func configureFor(viewModel: VM) {
            imageView.setPhoto(viewModel.photo)
            titleLabel.attributedText = regularTextStyler
                .attributedString(viewModel.title, color: .craftBeerTextTitleColor, forStyle: .footnote)
                .settingParagraphStyle{
                    $0.alignment = .center
                    $0.lineHeightMultiple = Constants.LineHeightMultiple
                }
        }
    }
    
    //MARK: InlineCell
    
    class InlineCell: UICollectionViewCell, ViewModelReusable {
        
        struct VM {
            let ID: Int
            let title: String
            let photo: Photo
        }
        
        private let imageView = UIImageView()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            contentView.addAutolayoutSubview(imageView)
            imageView.contentMode = .scaleAspectFit
            imageView.clipsToBounds = true
            
            imageView.pinToSuperview()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func configureFor(viewModel: VM) {
            imageView.setPhoto(viewModel.photo)
        }
    }
    
    //MARK: HeaderView
    
    class HeaderView: UICollectionReusableView, ViewModelReusable {
        
        struct VM {
            let title: String?
        }
        
        private let titleLabel = UILabel()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            backgroundColor = .craftBeerBackgroundColor
            
            addAutolayoutSubview(titleLabel)
            titleLabel.pinToSuperview()
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func configureFor(viewModel: VM) {
            guard let title = viewModel.title else { return }
            titleLabel.attributedText = boldTextStyler
                .attributedString(title, color: .orange, forStyle: .title3)
        }
    }
}

private class RoundView: UIView {
    override class var layerClass: AnyClass {
        RoundLayer.self
    }
}
