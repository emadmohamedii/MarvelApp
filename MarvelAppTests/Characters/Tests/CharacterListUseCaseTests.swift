//
//  CharacterListUseCaseTests.swift
//  MarvelAppTests
//
//  Created by Emad Habib on 11/11/2024.
//

import XCTest
import Combine

@testable import MarvelApp

final class CharacterListUseCaseTests: XCTestCase {
    
    var mockCharacterRepository: MockCharacterRepository!
    var fetchCharacterListUseCase: MockFetchCharacterListUseCase!
    private var cancellables: Set<AnyCancellable> = []

    override func setUpWithError() throws {
        cancellables = Set<AnyCancellable>()
        // Initialize the mock repository
        mockCharacterRepository = MockCharacterRepository()
        // Initialize the use case with the mock dependency
        fetchCharacterListUseCase = MockFetchCharacterListUseCase(mockCharacterRepository: mockCharacterRepository)
    }
    
    override func tearDownWithError() throws {
        // Unregister the mock repository from Resolver
        mockCharacterRepository = nil
        fetchCharacterListUseCase = nil
        cancellables = Set<AnyCancellable>()
    }
    
    func testFetchCharacterList_success() {
        // Given
        let expectedResult = CharactersResult(descriptionField: "Iron Man Description", id: 1, name: "Iron Man", thumbnail: .init(ext: "jpg", path: "image"))
        let expectedCharacter = CharacterModel(from: expectedResult)
        mockCharacterRepository.characterListReturnValue = [expectedCharacter]
        
        // When
        let expectation = self.expectation(description: "Character List Fetched")
        var fetchedCharacters: [CharacterModel]?
        var fetchError: Error?
        
        fetchCharacterListUseCase.execute(with: CharactersRequest())
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    fetchError = error
                }
            }, receiveValue: { characters in
                fetchedCharacters = characters
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        // Then
        waitForExpectations(timeout: 1.0, handler: nil)  // Increase timeout if necessary
        XCTAssertNil(fetchError)
        XCTAssertEqual(fetchedCharacters?.count, 1)
        XCTAssertEqual(fetchedCharacters?.first?.name, "Iron Man")
    }
    
    func testFetchCharacterList_failure() {
        // Given
        let expectedError = NSError(domain: "TestError", code: 1, userInfo: nil)
        mockCharacterRepository.errorToReturn = expectedError

        // When
        let expectation = self.expectation(description: "Fetch Character List Failed")
        var fetchError: Error?

        fetchCharacterListUseCase.execute(with: CharactersRequest())
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    fetchError = error
                    expectation.fulfill()
                }
            }, receiveValue: { _ in })
            .store(in: &cancellables)

        // Then
        waitForExpectations(timeout: 1.0, handler: nil)
        XCTAssertNotNil(fetchError)
        XCTAssertEqual(fetchError as? NSError, expectedError)
    }

}
