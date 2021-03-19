
import Foundation
import EssentialKit
import Task

import XCTest

class HTTPBINAPITests: XCTestCase {
    
    func testIPEndpoint() {
        let getIP = HTTPBin.API.ip
        XCTAssert(getIP.path == "/ip")
        XCTAssert(getIP.method == .GET)
    }
    
    func testParseIPResponse() throws {
        let json =  """
                        { "origin": "80.34.92.76" }
                    """.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        let response = try decoder.decode(HTTPBin.Responses.IP.self, from: json)
        XCTAssert(response.origin == "80.34.92.76")
    }
}

enum HTTPBin {
    enum Hosts: Environment {
        case production
        case development
        
        var baseURL: URL {
            switch self {
            case .production:
                return URL(string: "https://httpbin.org")!
            case .development:
                return URL(string: "https://dev.httpbin.org")!
            }
        }
    }
    
    enum API: Endpoint {
        case ip
        case orderPizza
        
        var path: String {
            switch self {
            case .orderPizza:
                return "/forms/post"
            case .ip:
                return "/ip"
            }
        }
        
        var method: HTTPMethod {
            switch self {
            case .orderPizza:
                return .POST
            default:
                return .GET
            }
        }
    }
}

//MARK: Responses

extension HTTPBin {
    enum Responses {
        struct IP: Decodable {
            let origin: String
        }
    }
}
