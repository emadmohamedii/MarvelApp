//
//  CharacterRepoImple.swift
//  MarvelApp
//
//  Created by Emad Habib on 08/11/2024.
//

import CoreNetwork
import Combine
import Foundation
import Common

final class CharacterRepoImpl: CharacterRepoProtocol {
    @Injected private var apiClient: APIClientProtocol
    
    init() {}
    
    func fetchCharacterList(with parameters: CharactersRequest) -> AnyPublisher<CharactersResponse, Error> {
        let configuration = APIRequestConfiguration(
            router: CharactersRouter.chars_listing,
            method: .get(parameters: parameters)
        )
        
        return Future<CharactersResponse, Error> { promise in
            self.apiClient.performRequest(with: configuration) { (result: Result<CharactersResponse, Error>) in
                switch result {
                case .success(let data):
                    promise(.success(data))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
