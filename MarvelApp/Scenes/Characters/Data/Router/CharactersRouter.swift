//
//  CharactersRouter.swift
//  MarvelApp
//
//  Created by Emad Habib on 08/11/2024.
//

import CoreNetwork

enum CharactersRouter: APIRouterProtocol {
    case chars_listing
    case character_media(MediaRequest)
    
    var path: String {
        switch self {
        case.chars_listing:
            return "/characters"
        case let .character_media(request):
            return "/characters/\(request.charId)/\(request.mediaType)"
        }
    }
}
