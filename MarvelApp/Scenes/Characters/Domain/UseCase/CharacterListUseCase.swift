//
//  CharacterListUseCase.swift
//  MarvelApp
//
//  Created by Emad Habib on 08/11/2024.
//
import Combine
import Common

protocol CharacterListFetching {
    func execute(with parameters: CharactersRequest) -> AnyPublisher<[CharacterModel], Error>
}

final class FetchCharacterListUseCase: CharacterListFetching{
    @Injected private var repository: CharacterRepositoryFetchable
    
    /// Executes the character list fetch with specified parameters.
    ///
    /// - Parameter parameters: The `CharactersRequest` with filtering or pagination options for the request.
    /// - Returns: An `AnyPublisher` emitting an array of `CharacterModel` objects on success, or an `Error` on failure.
    
    func execute(with parameters: CharactersRequest) -> AnyPublisher<[CharacterModel], Error> {
        return repository.fetchCharacterList(with: parameters)
    }
}
