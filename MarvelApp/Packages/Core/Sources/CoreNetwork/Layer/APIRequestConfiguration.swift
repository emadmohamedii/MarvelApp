//
//  APIRequestConfiguration.swift
//  TMDB
//
//  Created by Eslam Abo El Fetouh on 20/12/2023.
//

import Foundation
import Alamofire

public protocol APIRequestConfigurationProtocol {
    var router: APIRouterProtocol { get }
    var apiVersion: APIClient.APIVersion { get }
    var method: APIClient.RequestMethod { get }
    var header: HTTPHeaders { get }
    
    init(router: APIRouterProtocol,
         apiVersion: APIClient.APIVersion,
         method: APIClient.RequestMethod,
         header: HTTPHeaders)
}

public struct APIRequestConfiguration: APIRequestConfigurationProtocol {
    public let router: APIRouterProtocol
    public let apiVersion: APIClient.APIVersion
    public let method: APIClient.RequestMethod
    public let header: HTTPHeaders
    
    public init(router: APIRouterProtocol,
                apiVersion: APIClient.APIVersion = .v3,
                method: APIClient.RequestMethod,
                header: HTTPHeaders = [:]) {
        self.router = router
        self.apiVersion = apiVersion
        self.method = method
        self.header = header
    }
}
