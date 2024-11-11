//
//  MockCharacterRepository.swift
//  MarvelApp
//
//  Created by Emad Habib on 11/11/2024.
//
@testable import MarvelApp
import Combine

final class MockCharacterRepository: CharacterRepositoryFetchable {
    var fetchCharacterListCalled = false
    var characterListReturnValue: [CharacterModel] = []
    var errorToReturn: Error?
    
    func fetchCharacterList(with parameters: CharactersRequest) -> AnyPublisher<[CharacterModel], Error> {
        fetchCharacterListCalled = true
        if let error = errorToReturn {
            return Fail(error: error).eraseToAnyPublisher()
        }
        return Just(characterListReturnValue)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
