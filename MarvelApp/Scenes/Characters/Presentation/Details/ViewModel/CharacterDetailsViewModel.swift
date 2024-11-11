//
//  CharacterDetailsViewModel.swift
//  MarvelApp
//
//  Created by Emad Habib on 09/11/2024.
//

import Combine
import Common
import Foundation

/// A type alias for the result of a media fetch operation.
typealias MediaFetchResult = (Result<[CharacterMediaModel], Error>) -> Void

final class CharacterDetailViewModel: ObservableObject {
    
    // MARK: - Injected Dependencies
    @Injected private var useCase: CharacterMediaFetching
    
    // MARK: - Published Properties
    @Published var sections: [CharDetailSectionOfCustomData] = []
    @Published var updateSection: CharDetailSectionOfCustomData?
    @Published var isLoading: Bool = false
    
    // MARK: - Private Properties
    private var charModel: CharacterModel
    private var cancellables: Set<AnyCancellable> = []
    private let dispatchGroup = DispatchGroup()
    
    // MARK: - Initializer
    /// Initializes the view model with a character model.
    /// - Parameter charModel: The character model containing the details of the selected character.
    init(charModel: CharacterModel) {
        self.charModel = charModel
        createSections()
    }
    
    // MARK: - Private Methods
    
    /// Creates the initial sections, including the character's header and media sections.
    private func createSections(){
        self.sections.append(createHeaderSections())
        self.sections.append(contentsOf: createMediaSections())
        fetchMediaWithDispatchGroup(charID: charModel.id)
    }
    
    private func createHeaderSections() -> CharDetailSectionOfCustomData{
        CharDetailSectionOfCustomData(
            headerType: .header,
            items: [.init(
                name: charModel.name,
                id: charModel.id,
                image: charModel.imageURL,
                desc: charModel.descriptionField,
                type: .header
            )]
        )
    }
    
    private func createMediaSections() -> [CharDetailSectionOfCustomData]{
        return MediaType.allCases.map { CharDetailSectionOfCustomData(
            headerType: $0.sectionType,
            header: $0.title,
            items: [], // Empty items initially
            loading: false // Assuming you want to start with a "not loading" state
        )
        }
    }
    
    /// Fetches media data for the character asynchronously using a dispatch group.
    /// - Parameter charID: The ID of the character for which media needs to be fetched.
    private func fetchMediaWithDispatchGroup(charID: Int) {
        self.isLoading = true
        
        // Iterate over all MediaTypes and fetch data asynchronously
        for type in MediaType.allCases {
            dispatchGroup.enter() // Enter the group for each task
            fetchCharacterMedia(
                with: charID,
                mediaType: type
            ) { [weak self] result in
                guard let self else {return}
                switch result {
                case .success(let media):
                    // If media contains valid URLs, set the media data for the respective type.
                    if media.filter({$0.imageURL?.isNotNullOrEmpty ?? false}).isNotEmpty {
                        self.setMediaValue(results: media, type: type)
                    }
                case .failure(let error):
                    debugPrint("Error fetching \(type): \(error)")
                }
                dispatchGroup.leave() // Leave the group when the task is done
            }
        }
        
        // Notify when all media fetch tasks are finished.
        dispatchGroup.notify(queue: .main) {
            self.isLoading = false
            debugPrint("All media fetched")
        }
    }
    
    /// Sets the media values for the respective media type in the sections.
    /// - Parameters:
    ///   - results: The fetched media data.
    ///   - type: The type of media (comics, events, stories, series).
    private func setMediaValue(results: [CharacterMediaModel], type: MediaType) {
        
        // Create sections for each media type and add them to the `sections` array.
        let items: [CharDetailSection] = [.init(
            type: type.sectionType,
            comics: type.sectionType == .comics ? results : nil,
            events: type.sectionType == .events ? results : nil,
            stories: type.sectionType == .stories ? results : nil,
            series: type.sectionType == .series ? results : nil
        )]
        
        if let index = sections.firstIndex(where: { $0.headerType == type.sectionType }) {
            // If the section exists, update the items of that section in the array
            var section = sections[index]
            section.items = items
            updateSection = section
        }
    }
    
    /// Fetches character media from the use case asynchronously.
    /// - Parameters:
    ///   - characterId: The character's ID.
    ///   - mediaType: The type of media to fetch (e.g., comics, events).
    ///   - completionHandler: A closure to handle the fetch result.
    private func fetchCharacterMedia(
        with characterId: Int,
        mediaType:MediaType,
        completionHandler:@escaping MediaFetchResult
    ) {
        let request = MediaRequest(
            charId: characterId,
            mediaType: mediaType
        )
        // Execute the media request using the use case.
        useCase.execute(with: request)
            .sink { completion in
                switch completion {
                case .finished:()
                case .failure(let error):
                    completionHandler(.failure(error))
                }
            } receiveValue: { data in
                completionHandler(.success(data))
            }
            .store(in: &cancellables)
    }
}
