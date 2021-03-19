//
//  Created by Michele Restuccia on 18/3/21.
//

import XCTest
import Task
@testable import CraftBeer

class BeerDetailsViewControllerTests: CraftBeerSnapshotTests {
    
    override func setUp() {
        super.setUp()
        let datasource = MockDataSource()
        Current.beerDetailsDataSourceFactory = { _ in datasource }
    }
    
    func test_layout() {
        let vc = BeerDetailsViewController(ID: 12345)
        let navVC = UINavigationController(rootViewController: vc)
        waitABitAndVerify(viewController: navVC)
    }
}

private class MockDataSource: BeerDetailsDataSourceType {
    var ID: Int { 12345 }
    
    func fetchBeerDetails() -> Task<BeerDetailsViewController.VM> {
        .init(success: .init(contentVM: .init(basicInfoVM: BeerMockData.basicInfoVM), actionVM: .inStock))
    }
}
