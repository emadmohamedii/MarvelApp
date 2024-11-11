//
//  App+Injection.swift
//  MarvelApp
//
//  Created by Emad Habib on 08/11/2024.
//

import CoreNetwork
import Common

extension Resolver: @retroactive ResolverRegistering {
    public static func registerAllServices() {
        register { NetworkLayerConfig() as NetworkLayerConfigProtocol}.scope(.application)
        register { APIClient(networkConfig: resolve()) as APIClientProtocol}.scope(.application)
        registerCharacter()
    }
}
