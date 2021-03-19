//
//  Created by Michele Restuccia on 5/3/21.
//

import UIKit
import EssentialKit

class BeerListViewController: UIViewController {
    
    enum Constants {
        static let SmallSpacing: CGFloat = 4
        static let NormalSpacing: CGFloat = 8
        static let Spacing: CGFloat = 16
        static let BigSpacing: CGFloat = 24
        static let HeaderHeight: CGFloat = 44
        static let LineHeightMultiple: CGFloat = 1.3
    }
    
    typealias VM = CollectionView.VM
    
    private let searchController = UISearchController.withPlaceholder(
        "search-placeholder-searchbar".localized
    )
    private let collectionView = CollectionView()
    
    private let dataSource = Current.beerListDataSourceFactory()
    private var nextPage = 0
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .craftBeerBackgroundColor
        view.addAutolayoutSubview(collectionView)
        collectionView.backgroundColor = .clear
        collectionView.pinToSuperview()
        
        addNavbarTitleView()
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData(animated: true)
    }
    
    //MARK: Private
    
    private func fetchData(animated: Bool) {
        nextPage = 1
        let currentPage = nextPage
        fetchData(taskGenerator: { [unowned self] in
            self.dataSource.fetchBeerList(currentPage: currentPage)
        },
        animated: animated,
        errorMessage: "error-fetch".localized,
        completion: { [weak self] vm in
            guard let `self` = self else { return }
            self.collectionView.configureFor(viewModel: vm)
            self.nextPage = currentPage + 1
        })
    }
    
    //MARK: Actions
    
    @objc func navigateToBeer(ID: Int) {
        let vc = BeerDetailsViewController(ID: ID)
        show(vc, sender: nil)
    }
    
    @objc func showToDo() {
        showTodoAlert()
    }
}

extension BeerListViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        showTodoAlert()
        return false
    }
}

extension BeerListViewController: AppModule {
    var shouldShowNotification: Bool { true }
    var analyticsName: String? { "BeerListViewController" }
}
