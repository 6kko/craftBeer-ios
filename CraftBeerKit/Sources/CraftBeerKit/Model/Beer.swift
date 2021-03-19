//
//  Created by Michele Restuccia on 6/3/21.
//

import Foundation

public struct Beer {
    public let id: Int
    public let name: String
    public let tagline: String
    public let description: String
    public let imageURL: URL?
    public let alcohol: Double
    public let bitter: Double?
    public let color: Double?
}

extension Beer: Decodable {
    enum CodingKeys: String, CodingKey {
        case id, name, tagline, description, ingredients
        case imageURL = "image_url"
        case alcohol = "abv"
        case bitter = "ibu"
        case color = "srm"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        tagline = try container.decode(String.self, forKey: .tagline)
        description = try container.decode(String.self, forKey: .description)
        imageURL = {
            guard let urlString = try? container.decode(String.self, forKey: .imageURL) else { return nil }
            return URL(string: urlString)
        }()
        alcohol = try container.decode(Double.self, forKey: .alcohol)
        bitter = try? container.decode(Double.self, forKey: .bitter)
        color = try? container.decode(Double.self, forKey: .color)
    }
}
