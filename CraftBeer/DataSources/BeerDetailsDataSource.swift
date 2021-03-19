//
//  Created by Michele Restuccia on 10/3/21.
//

import Foundation
import EssentialKit
import CraftBeerKit
import Task

protocol BeerDetailsDataSourceType {
    
    /// Represents the ID of the
    var ID: Int { get }
    
    func fetchBeerDetails() -> Task<BeerDetailsViewController.VM>
}

class BeerDetailsDataSource: BeerDetailsDataSourceType {
    
    let ID: Int
    private let apiClient: PunkAPIClient
    
    init(apiClient: PunkAPIClient, ID: Int) {
        self.apiClient = apiClient
        self.ID = ID
    }
    
    func fetchBeerDetails() -> Task<BeerDetailsViewController.VM> {
        return apiClient.fetchBeer(with: ID).map(upon: .main) {
            $0.viewModel
        }
    }
}

private extension Beer {
    var viewModel: BeerDetailsViewController.VM {
        
        let basicInfoVM: BeerDetailsViewController.ContentViewController.BasicInfoView.VM = {
            .init(
                title: name,
                subtitle: tagline,
                description: description,
                alcohol: alcohol,
                bitter: bitter,
                color: color,
                photos: [Photo(url: imageURL)]
            )
        }()
        
        return .init(
            contentVM: .init(basicInfoVM: basicInfoVM),
            actionVM: .inStock
        )
    }
}
