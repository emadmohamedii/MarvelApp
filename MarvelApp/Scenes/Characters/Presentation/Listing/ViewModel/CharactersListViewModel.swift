//
//  CharactersListViewModel.swift
//  MarvelApp
//
//  Created by Emad Habib on 08/11/2024.
//
import Combine
import Foundation
import Common

final class CharactersListViewModel: ObservableObject {
    
    @Injected private var useCase: CharacterListFetching
    @Published var characters: [CharacterModel] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var isLastPage: Bool = false
    // Current page and page size for pagination
    let callNextPage = PassthroughSubject<Void, Never>()
    private var currentPage = 0
    private let pageSize = 10
    private var cancellables: Set<AnyCancellable> = []
    private var coordinator: CharacterCoordinator?
    
    init() {
        // Observe loadNextPagePublisher to trigger loading more data
        callNextPage
            .sink { [weak self] _ in
                self?.loadMoreData()
            }
            .store(in: &cancellables)
    }
    
    
    /// Fetches the list of characters based on the given parameters.
    ///
    /// - Parameter parameters: `CharactersRequest` object that contains search or pagination parameters.
    func fetchCharacterList(with parameters: CharactersRequest) {
        isLoading = true
        errorMessage = nil
        
        useCase.execute(with: parameters)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    self?.isLoading = false
                case .failure(let error):
                    self?.isLoading = false
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] characters in
                guard let self else {return}
                // When fetching for the first time, update characters
                self.characters = characters
                
                // just check if get characters for search so if no result you can show an error no data returned or founded by server
                if parameters.name?.isNotNullOrEmpty ?? false, self.characters.isEmpty {
                    self.errorMessage = "No Search Data Found"
                }
            }
            .store(in: &cancellables)
    }
    
    /// Clears the search results and resets the pagination state.
    func clearSearchResult(){
        self.currentPage = 0
        self.characters = []
    }
    
    /// Loads more characters based on pagination settings.
    private func loadMoreData() {
        guard !isLoading && !isLastPage else { return }
        
        isLoading = true
        currentPage += 1
        
        // Update the parameters for the next page (offset depends on the current page)
        let request = CharactersRequest(
            limit: pageSize,
            offset: currentPage * pageSize
        )
        
        useCase.execute(with: request)
            .sink { [weak self] completion in
                guard let self else {return}
                switch completion {
                case .finished:
                    self.isLoading = false
                case .failure:
                    self.isLoading = false
                }
            } receiveValue: { [weak self] newCharacters in
                guard let self else {return}
                // Append new characters to the existing list
                self.characters = newCharacters
                // If the new items count is less than the page size, we are on the last page
                if newCharacters.count < self.pageSize {
                    self.isLastPage = true
                }
            }
            .store(in: &cancellables)
    }
}
