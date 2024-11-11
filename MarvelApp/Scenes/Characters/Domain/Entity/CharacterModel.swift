//
//  CharacterModel.swift
//  MarvelApp
//
//  Created by Emad Habib on 10/11/2024.
//

import Foundation

struct CharacterModel: Identifiable {
    let descriptionField: String?
    let id: Int
    let name: String
    private let thumbnail: CharactersThumbnail?
    
    var imageURL: String? {
        guard let path = thumbnail?.path, let ext = thumbnail?.ext else {
            return nil
        }
        return "\(path).\(ext)"
    }
    
    init(from result: CharactersResult) {
        self.id = result.id ?? 0
        self.name = result.name ?? "Unknown"
        self.descriptionField = result.descriptionField
        self.thumbnail = result.thumbnail
    }
}
