//
//  Created by Michele Restuccia on 8/3/21.
//

import Foundation

public struct StorePreferences {
    public let banners: [Banner]
    public let features: [Feature]
    
    public struct Banner {
        public let imageURL: URL?
    }
    
    public struct Feature {
        public let title: String
        public let imageURL: URL?
    }
}

extension StorePreferences: Decodable {
    enum CodingKeys: String, CodingKey {
        case banners, features
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        banners = {
            guard let array = try? container.decode([Banner].self, forKey: .banners) else { return [] }
            return array
        }()
        features = {
            guard let array = try? container.decode([Feature].self, forKey: .features) else { return [] }
            return array
        }()
    }
}

extension StorePreferences.Banner: Decodable {
    enum CodingKeys: String, CodingKey {
        case imageURL
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        imageURL = {
            guard let urlString = try? container.decode(String.self, forKey: .imageURL) else { return nil }
            return URL(string: urlString)
        }()
    }
}


extension StorePreferences.Feature: Decodable {
    enum CodingKeys: String, CodingKey {
        case title, imageURL
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decode(String.self, forKey: .title)
        imageURL = {
            guard let urlString = try? container.decode(String.self, forKey: .imageURL) else { return nil }
            return URL(string: urlString)
        }()
    }
}
