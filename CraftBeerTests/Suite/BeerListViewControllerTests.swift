//
//  Created by Michele Restuccia on 5/3/21.
//

import XCTest
import Task
@testable import CraftBeer

class BeerListViewControllerTests: CraftBeerSnapshotTests {
    
    override func setUp() {
        super.setUp()
        let datasource = MockDataSource()
        Current.beerListDataSourceFactory = { datasource }
    }
    
    func test_layout() {
        let vc = BeerListViewController()
        let navVC = UINavigationController(rootViewController: vc)
        waitABitAndVerify(viewController: navVC)
    }
}

private class MockDataSource: BeerListDataSourceType {
    
    func fetchBeerList(currentPage: Int) -> Task<BeerListViewController.VM> {
        .init(success: .init(
            bannerVM: BeerMockData.bannerVM,
            featureVM: BeerMockData.featureVM,
            blocksVM: BeerMockData.blocksVM,
            inlineVM: BeerMockData.inlineVM
        ))
    }
}
