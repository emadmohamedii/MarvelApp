//
//  CharacterRepoProtocol.swift
//  MarvelApp
//
//  Created by Emad Habib on 08/11/2024.
//
import Foundation
import Combine

/// Protocol defining methods for fetching character data.
protocol CharacterRepositoryFetchable {
    /// Fetches a list of characters based on the specified parameters.
    /// - Parameter parameters: The request parameters for filtering or sorting the character list.
    /// - Returns: A publisher that outputs an array of `CharacterModel` or an error if the operation fails.
    func fetchCharacterList(with parameters: CharactersRequest) -> AnyPublisher<[CharacterModel], Error>
}
