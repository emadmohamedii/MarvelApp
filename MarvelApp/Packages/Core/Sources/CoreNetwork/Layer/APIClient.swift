//
//  APIClient.swift
//  TMDB
//
//  Created by Eslam Abo El Fetouh on 20/12/2023.
//

import Foundation
import Alamofire
import CommonCrypto

// Protocol defining the API client's behavior
public protocol APIClientProtocol {
    func performRequest<T:Decodable>(with configuration: APIRequestConfigurationProtocol,
                                     completion: @escaping (Result<T,Error>) -> Void)
}

// Singleton class implementing the API client
final public class APIClient: APIClientProtocol {
    // Singleton instance
    private var networkConfig: NetworkLayerConfigProtocol
    private var session: Session
    // Private initializer to enforce singleton pattern
    public init(networkConfig: NetworkLayerConfigProtocol) {
        self.networkConfig = networkConfig
        
        // Configure the URLSession with custom timeouts
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30  // Timeout for individual requests (e.g., network latency)
        configuration.timeoutIntervalForResource = 60 // Timeout for the entire resource request (e.g., multiple redirects)
        
        // Create a custom Alamofire session with the configuration
        session = Session(configuration: configuration)
    }
    
    // MARK: Configure networkConfig
    public func configClient(_ configuration: NetworkLayerConfigProtocol) {
        self.networkConfig = configuration
    }
}

// Build and Perform request
extension APIClient {
    public func performRequest<T:Decodable>(with configuration: APIRequestConfigurationProtocol,
                                            completion: @escaping (Result<T,Error>) -> Void) {
        let url = buildURL(with: configuration)
        let requestMethod = determineRequestMethod(from: configuration.method)
        let requestParameters = buildRequestParameters(from: configuration.method)
        makeRequest( with: .init(url: url,
                                 method: requestMethod,
                                 headers: configuration.header,
                                 parameters: requestParameters),
                     completion: completion)
    }
    
    private func buildURL(with configuration: APIRequestConfigurationProtocol) -> String {
        return networkConfig.apiBaseURL +
        configuration.router.path +
        HashGenerator.getCredentials(networkConfig: networkConfig)
    }
    
    private func determineRequestMethod(from method: APIClient.RequestMethod) -> HTTPMethod {
        switch method {
        case .post:
            return .post
        case .get:
            return .get
        }
    }
    
    private func buildRequestParameters(from method: APIClient.RequestMethod) -> [String: Any]? {
        switch method {
        case .post(let parameters):
            return try? JSONSerialization.jsonObject(with: JSONEncoder().encode(parameters)) as? [String: Any]
        case .get(let parameters):
            guard let parameters = parameters else { return nil }
            return try? JSONSerialization.jsonObject(with: JSONEncoder().encode(parameters)) as? [String: Any]
        }
    }
    
    private func makeRequest<T:Decodable>(with builder: RequestBuilder,
                                          completion: @escaping (Result<T,Error>) -> Void) {
        session.request(builder.url,
                   method: builder.method,
                   parameters: builder.parameters,
                   headers: builder.headers)
        .validate(statusCode: 200..<300)
        .responseDecodable(of: T.self) { response in
            DispatchQueue.main.async {
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
}

// Enums related to the API client
public extension APIClient {
    // MARK: HTTP request methods
    enum RequestMethod {
        case get(parameters: Encodable? = nil)
        case post(parameters: Encodable)
    }
}
// Models related to API client
private extension APIClient {
    struct RequestBuilder {
        let url: String
        let method: HTTPMethod
        var headers: HTTPHeaders
        let parameters: [String: Any]?
    }
}
