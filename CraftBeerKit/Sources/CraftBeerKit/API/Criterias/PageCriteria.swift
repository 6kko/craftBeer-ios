//
//  Created by Michele Restuccia on 13/3/21.
//

import Foundation

public struct PageCriteria {
    public let pageSize: Int
    public let currentPage: Int
    
    public init(currentPage: Int, pageSize: Int = PunkAPIClient.Configuration.PageSize) {
        self.pageSize = pageSize
        self.currentPage = currentPage
    }
    
    public var parameters: [String: Any] {
        return [
            "pageSize": pageSize,
            "currentPage": currentPage
        ]
    }
}
