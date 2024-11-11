//
//  Character+Injection.swift
//  MarvelApp
//
//  Created by Emad Habib on 08/11/2024.
//

import Common

extension Resolver {
    public static func registerCharacter() {
        register { CharacterRepository() as CharacterRepositoryFetchable }
        register { MediaRepository() as MediaRepositoryFetchable }
        
        register { FetchCharacterListUseCase() as CharacterListFetching }
        register { CharacterMediaUseCase() as CharacterMediaFetching }
    }
}
