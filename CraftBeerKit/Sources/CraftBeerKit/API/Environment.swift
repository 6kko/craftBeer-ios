//
//  Created by Michele Restuccia on 6/3/21.
//

import EssentialKit
import Foundation

public struct Environment: EssentialKit.Environment {
    
    public let host: Host
    public let country: Country
    public let injectsMockToken: Bool

    public init(host: Host, country: Country, injectsMockToken: Bool = false) {
        self.host = host
        self.country = country
        self.injectsMockToken = injectsMockToken
    }
    
    public enum Host: String, CaseIterable {
        case production
    }
    
    public enum Country: String, CaseIterable {
        case spain
    }
    
    public var shouldAllowInsecureConnections: Bool { false }
    
    public var baseURL: URL {
        switch (host, country) {
        case (.production, .spain):
            return URL(string: "https://api.punkapi.com/v2/")!
        }
    }
    
    public var currentLocale: Locale {
        switch country {
        case .spain:    return .init(identifier: "es_ES")
        }
    }
}

extension Environment.Host: Codable {}
extension Environment.Country: Codable {}
extension Environment: Codable {}

#if DEBUG
public extension Environment {
    static var unitTest = Environment(host: .production, country: .spain, injectsMockToken: true)
}
#endif
