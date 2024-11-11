//
//  NetworkLayerConfig.swift
//  TMDB
//
//  Created by Eslam Abo El Fetouh on 21/12/2023.
//

import Foundation
import Alamofire

public protocol NetworkLayerConfigProtocol {
    var apiBaseURL: String {get}
    var publicApiKey: String {get}
    var privateApiKey: String {get}
}

final public class NetworkLayerConfig: NetworkLayerConfigProtocol {
    public init() {}
    
    lazy public var publicApiKey: String = {
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "PUBLIC_API_KEY") as? String else {
            fatalError("ApiKey must not be empty in plist")
        }
        return apiKey
    }()
    
    lazy public var privateApiKey: String = {
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "PRIVATE_API_KEY") as? String else {
            fatalError("ApiKey must not be empty in plist")
        }
        return apiKey
    }()
    
    lazy public var apiBaseURL: String = {
        guard let apiBaseString = Bundle.main.object(forInfoDictionaryKey: "API_BASE_URL") as? String else {
            fatalError("ApiBaseURL must not be empty in plist")
        }
        return apiBaseString
    }()
}
