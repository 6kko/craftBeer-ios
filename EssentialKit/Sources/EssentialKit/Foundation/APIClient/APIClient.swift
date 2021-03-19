//
//  Created by Michele Restuccia on 6/3/21.
//  Suggested by [PCifani](https://github.com/theleftbit)
//

import Foundation
import Task; import Deferred

public protocol APIClientNetworkFetcher {
    func fetchData(with urlRequest: URLRequest) -> Task<APIClient.Response>
}

public protocol APIClientDelegate: class {
    func apiClientDidReceiveUnauthorized(forRequest atPath: String, apiClient: APIClient) -> Task<()>?
    func apiClientDidReceiveError(_ error: Error, forRequest atPath: String, apiClient: APIClient)
}

open class APIClient {
    
    open weak var delegate: APIClientDelegate?
    open var delegateQueue = DispatchQueue.main
    private var router: Router
    private let workerQueue: OperationQueue
    private let networkFetcher: APIClientNetworkFetcher
    private let sessionDelegate: SessionDelegate
    open var mapError: (Swift.Error) -> (Swift.Error) = { $0 }
    open var customizeRequest: (URLRequest) -> (URLRequest) = { $0 }
    
    public init(environment: Environment, networkFetcher: APIClientNetworkFetcher? = nil) {
        let sessionDelegate = SessionDelegate(environment: environment)
        let queue = queueForSubmodule("APIClient", qualityOfService: .userInitiated)
        self.router = Router(environment: environment)
        self.networkFetcher = networkFetcher ?? URLSession(configuration: .default, delegate: sessionDelegate, delegateQueue: queue)
        self.workerQueue = queue
        self.sessionDelegate = sessionDelegate
    }
    
    public func perform<T: Decodable>(_ request: Request<T>) -> Task<T> {
        let task: Task<T> =
            createURLRequest(endpoint: request.endpoint)
            .andThen(upon: workerQueue) { self.customizeNetworkRequest(networkRequest: $0) }
            .andThen(upon: workerQueue) { self.sendNetworkRequest($0) }
            .andThen(upon: workerQueue) { request.performUserValidator(onResponse: $0, queue: self.delegateQueue) }
            .andThen(upon: workerQueue) { self.validateResponse($0) }
            .andThen(upon: workerQueue) { self.parseResponseData($0) }
            .recover(upon: workerQueue) { throw self.mapError($0) }
        return task.fallback(upon: delegateQueue) { (error) in
            return self.attemptToRecoverFrom(error: error, request: request)
        }
    }
    
    public var currentEnvironment: Environment {
        return self.router.environment
    }
}

public extension APIClient {
    
    enum Error: Swift.Error {
        case malformedURL
        case malformedParameters
        case malformedResponse
        case encodingRequestFailed
        case multipartEncodingFailed(reason: MultipartFormFailureReason)
        case malformedJSONResponse(Swift.Error)
        case failureStatusCode(Int, Data?)
        case requestCanceled
        case unknownError
    }
    
    struct Response {
        public let data: Data
        public let httpResponse: HTTPURLResponse
        
        public init(data: Data, httpResponse: HTTPURLResponse) {
            self.data = data
            self.httpResponse = httpResponse
        }
    }
}

// MARK: Private

private extension APIClient {
    
    typealias NetworkRequest = (request: URLRequest, fileURL: URL?)
    
    func customizeNetworkRequest(networkRequest: NetworkRequest) -> Task<NetworkRequest> {
        return Task.async(upon: self.delegateQueue, onCancel: APIClient.Error.requestCanceled) { () in
            return (self.customizeRequest(networkRequest.request), networkRequest.fileURL)
        }
    }
    
    func sendNetworkRequest(_ networkRequest: NetworkRequest) -> Task<APIClient.Response> {
        defer { logRequest(request: networkRequest.request) }
        return self.networkFetcher.fetchData(with: networkRequest.request)
    }
    
    func validateResponse(_ response: Response) -> Task<Data> {
        defer { logResponse(response)}
        switch response.httpResponse.statusCode {
        case (200..<300):
            return .init(success: response.data)
        default:
            let apiError = APIClient.Error.failureStatusCode(response.httpResponse.statusCode, response.data)
            
            if let path = response.httpResponse.url?.path {
                delegateQueue.async {
                    self.delegate?.apiClientDidReceiveError(apiError, forRequest: path, apiClient: self)
                }
            }
            
            return .init(failure: apiError)
        }
    }
    
    func parseResponseData<T: Decodable>(_ data: Data) -> Task<T> {
        return JSONParser.parseData(data)
    }
    
    func attemptToRecoverFrom<T: Decodable>(error: Swift.Error, request: Request<T>) -> Task<T> {
        guard error.is401,
              request.shouldRetryIfUnauthorized,
              let newSignatureTask = self.delegate?.apiClientDidReceiveUnauthorized(forRequest: request.endpoint.path, apiClient: self) else {
            return Task(failure: error)
        }
        let mutatedRequest = Request<T>(
            endpoint: request.endpoint,
            shouldRetryIfUnauthorized: false,
            validator: request.validator
        )
        return newSignatureTask.andThen(upon: workerQueue) { _ in
            return self.perform(mutatedRequest)
        }
    }
    
    func createURLRequest(endpoint: Endpoint) -> Task<(URLRequest, URL?)> {
        let deferred = Deferred<Task<(URLRequest, URL?)>.Result>()
        let operation = BlockOperation {
            do {
                let request = try self.router.urlRequest(forEndpoint: endpoint)
                deferred.fill(with: .success(request))
            } catch let error {
                deferred.fill(with: .failure(error))
            }
        }
        workerQueue.addOperation(operation)
        return Task(deferred, uponCancel: { [weak operation] in
            operation?.cancel()
        })
    }
    
    @discardableResult
    func deleteFileAtPath(fileURL: URL) -> Task<()> {
        let deferred = Deferred<Task<()>.Result>()
        FileManagerWrapper.shared.perform { fileManager in
            do {
                try fileManager.removeItem(at: fileURL)
                deferred.succeed(with: ())
            } catch let error {
                deferred.fail(with: error)
            }
        }
        return Task(deferred)
    }
    
    /// Proxy object to do all our URLSessionDelegate work
    class SessionDelegate: NSObject, URLSessionDelegate {
        
        let environment: Environment
        
        init(environment: Environment) {
            self.environment = environment
            super.init()
        }
        
        public func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
            if self.environment.shouldAllowInsecureConnections {
                completionHandler(.useCredential, URLCredential(trust: challenge.protectionSpace.serverTrust!))
            } else {
                completionHandler(.performDefaultHandling, nil)
            }
        }
    }
}

import os.log
private extension APIClient {
    
    func logRequest(request: URLRequest) {
        let customLog = OSLog(subsystem: submoduleName("APIClient"), category: "APIClient.Request")
        let httpMethod = request.httpMethod ?? "GET"
        let path = request.url?.path ?? ""
        os_log("Method: %{public}@ Path: %{public}@", log: customLog, type: .debug, httpMethod, path)
        if let data = request.httpBody, let prettyString = String(data: data, encoding: .utf8) {
            os_log("Body: %{public}@", log: customLog, type: .debug, prettyString)
        }
    }
    
    private func logResponse(_ response: Response) {
        let isError = !(200..<300).contains(response.httpResponse.statusCode)
        let customLog = OSLog(subsystem: submoduleName("APIClient"), category: "APIClient.Response")
        let statusCode = NSNumber(value: response.httpResponse.statusCode)
        let path = response.httpResponse.url?.path ?? ""
        os_log("StatusCode: %{public}@ Path: %{public}@", log: customLog, type: .debug, statusCode, path)
        if isError, let errorString = String(data: response.data, encoding: .utf8) {
            os_log("Error Message: %{public}@", log: customLog, type: .error, errorString)
        }
    }
}

extension URLSession: APIClientNetworkFetcher {
    public func fetchData(with urlRequest: URLRequest) -> Task<APIClient.Response> {
        let deferred = Deferred<Task<APIClient.Response>.Result>()
        let task = self.dataTask(with: urlRequest) { (data, response, error) in
            self.analyzeResponse(deferred: deferred, data: data, response: response, error: error)
        }
        task.resume()
        return Task(deferred, progress: task.progress)
    }
    
    private func analyzeResponse(deferred: Deferred<Task<APIClient.Response>.Result>, data: Data?, response: URLResponse?, error: Error?) {
        guard error == nil else {
            deferred.fill(with: .failure(error!))
            return
        }
        
        guard let httpResponse = response as? HTTPURLResponse,
              let data = data else {
            deferred.fill(with: .failure(APIClient.Error.malformedResponse))
            return
        }
        
        deferred.fill(with: .success(APIClient.Response.init(data: data, httpResponse: httpResponse)))
    }
}

private extension Request {
    func performUserValidator(onResponse response: APIClient.Response, queue: DispatchQueue) -> Task<APIClient.Response> {
        return Task.async(upon: queue, onCancel: APIClient.Error.requestCanceled) { () in
            try self.validator(response)
            return response
        }
    }
}

public typealias HTTPHeaders = [String: String]
public struct VoidResponse: Decodable {}

private extension Swift.Error {
    var is401: Bool {
        guard
            let apiClientError = self as? APIClient.Error,
            case .failureStatusCode(let statusCode, _) = apiClientError,
            statusCode == 401 else {
            return false
        }
        return true
    }
}
