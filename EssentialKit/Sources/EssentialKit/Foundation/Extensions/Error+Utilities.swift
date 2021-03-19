//
//  Created by Michele Restuccia on 7/3/21.
//

import Foundation

public extension Error {
    var isURLCancelled: Bool {
        if let apiClientError = self as? APIClient.Error, case .requestCanceled = apiClientError {
            return true
        } else {
            let nsError = self as NSError
            return nsError.domain == NSURLErrorDomain && nsError.code == NSURLErrorCancelled
        }
    }
}
