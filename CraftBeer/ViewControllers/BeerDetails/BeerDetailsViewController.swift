//
//  Created by Michele Restuccia on 10/3/21.
//

import UIKit
import EssentialKit
import CraftBeerAccessibility

class BeerDetailsViewController: UIViewController, PhotoGalleryViewControllerDelegate {
    
    enum Constants {
        static let SmallSpacing: CGFloat = 4
        static let NormalSpacing: CGFloat = 8
        static let Spacing: CGFloat = 16
        static let BigSpacing: CGFloat = 24
        static let LineHeightMultiple: CGFloat = 1.3
        static let ButtonHeight: CGFloat = 48
        static let PhotoGalleryHeight: CGFloat = 220
    }
    
    struct VM {
        let contentVM: ContentViewController.VM
        let actionVM: ActionViewController.VM
    }
    var viewModel: VM! {
        didSet {
            contentVC.configureFor(viewModel: viewModel.contentVM)
            actionVC.configureFor(viewModel: viewModel.actionVM)
        }
    }
    
    private let ID: Int
    private lazy var dataSource = Current.beerDetailsDataSourceFactory(ID)
    
    private let contentVC = ContentViewController()
    private let actionVC = ActionViewController()
    
    init(ID: Int) {
        self.ID = ID
        super.init(nibName: nil, bundle: nil)
        hidesBottomBarWhenPushed = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .craftBeerBackgroundColor
        containViewController(
            BottomContainerViewController(
                containedViewController: contentVC,
                bottomViewController: actionVC
            )
        )
        
        /// Setup accesibility
        setCraftBeerIdentifier(.beerDetails)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData(animated: false)
        actionVC.actionButton.addTarget(self, action: #selector(onActionButtonPressed), for: .touchUpInside)
    }
    
    //MARK: Private
    
    private func fetchData(animated: Bool) {
        fetchData(taskGenerator: { [unowned self] in
            self.dataSource.fetchBeerDetails()
        },
        animated: animated,
        errorMessage: "error-fetch".localized,
        completion: { [weak self] vm in
            guard let `self` = self else { return }
            self.viewModel = vm
        })
    }
    
    //MARK: Actions
    
    @objc private func onActionButtonPressed() {
        showTodoAlert()
    }
    
    @objc func onOpenGallery(atCell: ContentViewController.BasicInfoView) {
        let index = atCell.currentlySelectedPhotoIndex
        let photosVC = PhotoGalleryViewController(
            photos: viewModel.contentVM.basicInfoVM.photos,
            initialPageIndex: index,
            allowShare: false
        )
        photosVC.delegate = self
        present(photosVC, animated: true, completion: nil)
    }
    
    //MARK: PhotoGalleryViewControllerDelegate
    
    func photoGalleryController(_ photoGalleryController: PhotoGalleryViewController, willDismissAtPageIndex index: Int) {
        contentVC.scrollToPhotoAt(index: index)
    }
}

extension BeerDetailsViewController: AppModule {
    var analyticsName: String? { "BeerDetailsViewController" }
}
