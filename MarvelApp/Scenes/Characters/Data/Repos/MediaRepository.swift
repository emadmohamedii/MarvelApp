//
//  CharacterDetailRepoImpl.swift
//  MarvelApp
//
//  Created by Emad Habib on 09/11/2024.
//

import CoreNetwork
import Combine
import Foundation
import Common

final class MediaRepository: MediaRepoProtocol {
    @Injected private var apiClient: APIClientProtocol
    
    init() {}
    
    func fetchCharacterMedia(with characterId: Int) -> AnyPublisher<CharDetailResponseModel, any Error> {
        let configuration = APIRequestConfiguration(
            router: CharactersRouter.character_comics(characterId: characterId),
            method: .get()
        )
        return Future<CharDetailResponseModel, Error> { promise in
            self.apiClient.performRequest(with: configuration) { (result: Result<CharDetailResponseModel, Error>) in
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
