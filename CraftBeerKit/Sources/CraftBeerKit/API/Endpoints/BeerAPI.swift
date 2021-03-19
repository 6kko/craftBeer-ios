//
//  Created by Michele Restuccia on 6/3/21.
//

import EssentialKit

enum BeerAPI: Endpoint {
    
    case getBeers(pageCriteria: PageCriteria)
    case getBeer(ID: Int)
    
    var path: String {
        switch self {
        
        case .getBeers:
            return "beers"
        
        case.getBeer(let ID):
            return "beers/\(ID)"
        }
    }
    
    var method: HTTPMethod {
        return .GET
    }
    
    var parameters: [String : Any]? {
        switch self {
        
        case .getBeers(let criteria):
            return criteria.parameters
        
        default:
            return nil
        }
    }
}
