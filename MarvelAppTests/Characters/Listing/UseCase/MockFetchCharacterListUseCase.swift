//
//  MockFetchCharacterListUseCase.swift
//  MarvelApp
//
//  Created by Emad Habib on 11/11/2024.
//

import XCTest
import Combine
@testable import MarvelApp

final class MockFetchCharacterListUseCase: CharacterListFetching {
    var mockCharacterRepository: MockCharacterRepository!
    
    init(mockCharacterRepository: MockCharacterRepository!) {
        self.mockCharacterRepository = mockCharacterRepository
    }
    
    func execute(with parameters: MarvelApp.CharactersRequest) -> AnyPublisher<[MarvelApp.CharacterModel], any Error> {
        mockCharacterRepository.fetchCharacterList(with: parameters)
    }
}
