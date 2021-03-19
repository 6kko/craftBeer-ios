//
//  Created by Michele Restuccia on 6/3/21.
//

import Foundation
import Task

public class MockNetworkFetcher: APIClientNetworkFetcher {
    
    public init() {}
    public var mockedData: Data!
    public var mockedStatusCode: Int = 200
    public var capturedURLRequest: URLRequest?
    
    public func fetchData(with urlRequest: URLRequest) -> Task<APIClient.Response> {
        self.capturedURLRequest = urlRequest
        let response = APIClient.Response(data: mockedData, httpResponse: HTTPURLResponse(url: urlRequest.url!, statusCode: mockedStatusCode, httpVersion: nil, headerFields: nil)!)
        return Task(success: response)
    }
    
    public func uploadFile(with urlRequest: URLRequest, fileURL: URL) -> Task<APIClient.Response> {
        self.capturedURLRequest = urlRequest
        let response = APIClient.Response(data: mockedData, httpResponse: HTTPURLResponse(url: urlRequest.url!, statusCode: mockedStatusCode, httpVersion: nil, headerFields: nil)!)
        return Task(success: response)
    }
}

