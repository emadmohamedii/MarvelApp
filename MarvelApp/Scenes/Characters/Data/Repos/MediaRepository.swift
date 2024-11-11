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

final class MediaRepository: MediaRepositoryFetchable {
    @Injected private var apiClient: APIClientProtocol
    
    func fetchCharacterMedia(with parameters: MediaRequest) -> AnyPublisher<[CharacterMediaModel], any Error> {
        let configuration = APIRequestConfiguration(
            router: CharactersRouter.character_media(parameters),
            method: .get()
        )
        return Future<[CharacterMediaModel], Error> { promise in
            self.apiClient.performRequest(with: configuration) { (result: Result<CharacterMediaResponse, Error>) in
                switch result {
                case .success(let response):
                    let characterModels = response.data?.results?.map { CharacterMediaModel(from: $0) } ?? []
                    promise(.success(characterModels))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
