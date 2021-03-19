//
//  Created by Michele Restuccia on 7/3/21.
//

import Foundation
import CraftBeerKit

/// It is the AppDelegate's responsability to initialise the world with the correct environment
var Current: World!

struct World {

    let environment: CraftBeerKit.Environment
    
    // From CraftBeerKit
    lazy var apiClient = PunkAPIClient(environment: environment)
    
    // From CraftBeer.app
    lazy var storePreferencesDataSource = StorePreferencesDataSource()
    
    var beerListDataSourceFactory: () -> (BeerListDataSourceType) = {
        BeerListDataSource(apiClient: Current.apiClient)
    }
    
    var beerDetailsDataSourceFactory: (Int) -> (BeerDetailsDataSourceType) = {
        BeerDetailsDataSource(apiClient: Current.apiClient, ID: $0)
    }
    
    var locale: Locale { environment.currentLocale }
}
