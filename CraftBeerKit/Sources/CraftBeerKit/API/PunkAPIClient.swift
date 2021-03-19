//
//  Created by Michele Restuccia on 6/3/21.
//

import EssentialKit
import Task; import Deferred

public class PunkAPIClient: APIClient {
    
    public func fetchBeers(pageCriteria: PageCriteria) -> Task<[Beer]> {
        let request = Request<[Beer]>(
            endpoint: BeerAPI.getBeers(pageCriteria: pageCriteria)
        )
        return perform(request)
    }
    
    public func fetchBeer(with ID: Int) -> Task<Beer> {
        let request = Request<[Beer]>(
            endpoint: BeerAPI.getBeer(ID: ID)
        )
        return perform(request).map(upon: .main) { $0.first! }
    }
    
    public enum Configuration {
        public static var PageSize: Int = 20
    }
}
 
