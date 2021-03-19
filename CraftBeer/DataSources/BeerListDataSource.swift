//
//  Created by Michele Restuccia on 7/3/21.
//

import Foundation
import EssentialKit
import CraftBeerKit
import Task

protocol BeerListDataSourceType {
    func fetchBeerList(currentPage: Int) -> Task<BeerListViewController.VM>
}

class BeerListDataSource: BeerListDataSourceType {
    
    private let apiClient: PunkAPIClient
    
    init(apiClient: PunkAPIClient) {
        self.apiClient = apiClient
    }
    
    func fetchBeerList(currentPage: Int) -> Task<BeerListViewController.VM> {
        return apiClient.fetchBeers(pageCriteria: .init(currentPage: currentPage)).map(upon: .main) {
            $0.viewModel(with: Current.storePreferencesDataSource.storePreferences)
        }
    }
}

private extension Array where Element == Beer {
    func viewModel(with storePreferences: StorePreferences) -> BeerListViewController.VM {
        .init(
            bannerVM: self.bannerVM(storePreferences: storePreferences),
            featureVM: self.featureCellVM(storePreferences: storePreferences),
            blocksVM: .init(title: "home-block-title".localized, contents: self.blockCellVM),
            inlineVM: .init(title: "home-inline-title".localized, contents: self.inlineCellVM)
        )
    }
}

private extension Array where Element == Beer {
    func bannerVM(storePreferences: StorePreferences) -> [BeerListViewController.CollectionView.BannerCell.VM] {
        storePreferences.banners.compactMap {
            Photo(url: $0.imageURL)
        }
    }
    
    func featureCellVM(storePreferences: StorePreferences) -> [BeerListViewController.CollectionView.FeatureCell.VM] {
        storePreferences.features.compactMap {
            .init(title: $0.title.localized, photo: Photo(url: $0.imageURL))
        }
    }
    
    var blockCellVM: [BeerListViewController.CollectionView.BlockCell.VM] {
        let filterItems = self.filter { $0.alcohol > 6 }
        let maxItemsShown = 5
        return filterItems.prefix(maxItemsShown).map {
            .init(ID: $0.id, title: $0.name, photo: Photo(url: $0.imageURL))
        }
    }
    
    var inlineCellVM: [BeerListViewController.CollectionView.InlineCell.VM] {
        let orderList = self.sorted { $0.color ?? 0 > $1.color ?? 0 }
        let maxItemsShown = 10
        return orderList.prefix(maxItemsShown).map {
            .init(ID: $0.id, title: $0.name, photo: Photo(url: $0.imageURL))
        }
    }
}
