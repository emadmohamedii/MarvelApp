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

final class CharacterRepository: CharacterRepositoryFetchable {
    @Injected private var apiClient: APIClientProtocol
        
    func fetchCharacterList(with parameters: CharactersRequest) -> AnyPublisher<[CharacterModel], Error> {
        let configuration = APIRequestConfiguration(
            router: CharactersRouter.chars_listing,
            method: .get(parameters: parameters)
        )
        
        return Future<[CharacterModel], Error> { promise in
            self.apiClient.performRequest(with: configuration) { (result: Result<CharactersResponse, Error>) in
                switch result {
                case .success(let response):
                    let characterModels = response.data?.results?.map { CharacterModel(from: $0) } ?? []
                    promise(.success(characterModels))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
