//
//  Created by Michele Restuccia on 13/3/21.
//

import UIKit
import EssentialKit

extension BeerDetailsViewController.ContentViewController {
    
    private typealias Constants = BeerDetailsViewController.Constants
    
    class BasicInfoView: UIView, ViewModelConfigurable, PhotoGalleryViewDelegate {
        
        struct VM {
            let title: String
            let subtitle: String
            let description: String
            let alcohol: Double
            let bitter: Double?
            let color: Double?
            let photos: [Photo]
        }
        
        private let photoGalleryView = PhotoGalleryView(imageContentMode: .scaleAspectFit)
        private let titleLabel = UILabel.unlimitedLinesLabel()
        private let subtitleLabel = UILabel.unlimitedLinesLabel()
        private let descriptionLabel = UILabel.unlimitedLinesLabel()
        private let alcoholLabel = UILabel()
        private let bitterLabel = UILabel()
        private let colorLabel = UILabel()
        
        init() {
            super.init(frame: .zero)
            photoGalleryView.delegate = self
            photoGalleryView.backgroundColor = .white
            photoGalleryView.roundCorners(radius: PillButton.RadiusButton)
            
            let titleStackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
            titleStackView.axis = .vertical
            titleStackView.spacing = Constants.NormalSpacing
            titleStackView.alignment = .leading
            
            let dataStackView = UIStackView(arrangedSubviews: [
                alcoholLabel, bitterLabel, colorLabel
            ])
            dataStackView.axis = .horizontal
            dataStackView.spacing = Constants.Spacing
            dataStackView.alignment = .firstBaseline
            alcoholLabel.dontMakeBiggerOrSmaller()
            bitterLabel.dontMakeBiggerOrSmaller()
            colorLabel.adjustsFontSizeToFitWidth = true
            
            let rootStackView = UIStackView(arrangedSubviews: [titleStackView, photoGalleryView, dataStackView, descriptionLabel])
            rootStackView.axis = .vertical
            rootStackView.spacing = Constants.Spacing
            rootStackView.setCustomSpacing(Constants.BigSpacing, after: descriptionLabel)
            
            addAutolayoutSubview(rootStackView)
            pinToSuperview()
            
            NSLayoutConstraint.activate([
                photoGalleryView.heightAnchor.constraint(equalToConstant: Constants.PhotoGalleryHeight),
                rootStackView.topAnchor.constraint(equalTo: topAnchor),
                rootStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
                rootStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
                rootStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
                rootStackView.widthAnchor.constraint(equalTo: widthAnchor)
            ])
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        // MARK: ViewModelConfigurable
        
        func configureFor(viewModel: VM) {
            titleLabel.attributedText = viewModel.titleAttributedText
            subtitleLabel.attributedText = viewModel.subtitleAttributedText
            descriptionLabel.attributedText = viewModel.descriptionAttributedText
            alcoholLabel.attributedText = viewModel.alcoholAttributedText
            bitterLabel.attributedText = viewModel.bitterAttributed.text
            bitterLabel.isHidden = viewModel.bitterAttributed.isHidden
            colorLabel.attributedText = viewModel.colorAttributed.text
            colorLabel.isHidden = viewModel.colorAttributed.isHidden
            photoGalleryView.photos = viewModel.photos
        }
        
        // MARK: PhotoGalleryViewDelegate
        
        func didTapPhotoAt(index: Int, fromView: UIView) {
            guard let nextResponder = next() as BeerDetailsViewController? else { return }
            nextResponder.onOpenGallery(atCell: self)
        }
        
        var currentlySelectedPhotoIndex: Int {
            get {
                photoGalleryView.currentPage
            } set {
                photoGalleryView.scrollToPhoto(atIndex: newValue)
            }
        }
    }
}

extension BeerDetailsViewController.ContentViewController.BasicInfoView.VM {
    var titleAttributedText: NSAttributedString {
        boldTextStyler.attributedString(title, color: .craftBeerTintColor, forStyle: .title2)
    }
    
    var subtitleAttributedText: NSAttributedString {
        regularTextStyler
            .attributedString(subtitle, color: .craftBeerTintColor, forStyle: .headline)
            .settingParagraphStyle { $0.lineHeightMultiple = 1.3 }
    }
    
    var descriptionAttributedText: NSAttributedString {
        regularTextStyler
            .attributedString(description, color: .craftBeerTintColor, forStyle: .footnote)
            .settingParagraphStyle { $0.lineHeightMultiple = 2 }
    }
    
    var alcoholAttributedText: NSAttributedString? {
        let txt = String(format: "beer-details-alcohol-title".localized, arguments: [String(alcohol)])
        return boldTextStyler.attributedString(txt, color: .craftBeerTintColor, forStyle: .footnote)
    }
    
    var bitterAttributed: (isHidden: Bool, text: NSAttributedString?) {
        guard let value = bitter else { return (true, nil) }
        let txt = String(format: "beer-details-bitter-title".localized, arguments: [String(value)])
        return (false, boldTextStyler.attributedString(txt, color: .craftBeerTintColor, forStyle: .footnote))
    }
    
    var colorAttributed: (isHidden: Bool, text: NSAttributedString?) {
        guard let value = color else { return (true, nil) }
        let txt = String(format: "beer-details-color-title".localized, arguments: [String(value)])
        return (false, boldTextStyler.attributedString(txt, color: .craftBeerTintColor, forStyle: .footnote))
    }
}
