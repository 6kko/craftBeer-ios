//
//  Created by Michele Restuccia on 6/3/21.
//

import XCTest
import EssentialKit
import Deferred
@testable import CraftBeerKit
import SnapshotTesting

class PunkAPIClientTests: XCTestCase {
    
    var apiClient: PunkAPIClient!
    var networkFetcher: MockNetworkFetcher!
    
    override func setUp() {
        super.setUp()
        networkFetcher = MockNetworkFetcher()
        apiClient = PunkAPIClient(
            environment: CraftBeerKit.Environment.unitTest, networkFetcher: networkFetcher
        )
    }
    
    func testFetchBeers() throws {
        networkFetcher.mockedData = MockJSON.beers.data
        let task = apiClient.fetchBeers(pageCriteria: .init(currentPage: 1))
        let result = try self.waitAndExtractValue(task)
        XCTAssert(result[0].name == "Buzz")
        XCTAssert(result[0].tagline == "A Real Bitter Experience.")
        XCTAssert(result[0].imageURL?.absoluteString == "https://images.punkapi.com/v2/keg.png")
        
        guard let urlRequest = networkFetcher.capturedURLRequest else {
            throw UnwrapFail()
        }
        assertSnapshot(matching: urlRequest, as: .curl)
    }
    
    func testFetchBeer() throws {
        networkFetcher.mockedData = MockJSON.beer.data
        let task = apiClient.fetchBeer(with: 4)
        let result = try self.waitAndExtractValue(task)
        XCTAssert(result.name == "Pilsen Lager")
        
        guard let urlRequest = networkFetcher.capturedURLRequest else {
            throw UnwrapFail()
        }
        assertSnapshot(matching: urlRequest, as: .curl)
    }
}
