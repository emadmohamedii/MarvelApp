//
//  MediaRepoProtocol.swift
//  MarvelApp
//
//  Created by Emad Habib on 09/11/2024.
//

import Foundation
import Combine

/// Protocol defining methods for fetching media related to characters.
protocol MediaRepositoryFetchable {
    /// Fetches character-related media based on the provided request parameters.
    /// - Parameter parameters: The `MediaRequest` containing any filters, pagination, or additional parameters
    /// needed to fetch the media.
    /// - Returns: An `AnyPublisher` that publishes an array of `CharacterMediaModel` on success, or an `Error` if
    /// the fetch fails.
    func fetchCharacterMedia(with parameters: MediaRequest) -> AnyPublisher<[CharacterMediaModel], any Error>
}
