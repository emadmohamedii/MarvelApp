//
//  MediaUseCase.swift
//  MarvelApp
//
//  Created by Emad Habib on 09/11/2024.
//
import Common
import Combine

protocol CharacterMediaFetching {
    func execute(with parameters: MediaRequest) -> AnyPublisher<[CharacterMediaModel], Error>
}

final class CharacterMediaUseCase: CharacterMediaFetching {
    
    @Injected private var repository: MediaRepositoryFetchable
    
    /// Executes the media fetch operation for a character based on specified parameters.
    ///
    /// - Parameter parameters: The `MediaRequest` object specifying query filters, character ID, or pagination details.
    /// - Returns: An `AnyPublisher` emitting an array of `CharacterMediaModel` objects on success, or an `Error` on failure.
    
    func execute(with parameters: MediaRequest) -> AnyPublisher<[CharacterMediaModel], Error> {
        return repository.fetchCharacterMedia(with: parameters)
    }
}
