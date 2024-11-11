//
//  CharacterMediaModel.swift
//  MarvelApp
//
//  Created by Emad Habib on 11/11/2024.
//

import Foundation

struct CharacterMediaModel: Identifiable {
    let id: Int
    let name: String
    private let thumbnail: CharactersThumbnail?

    var imageURL: String? {
        guard let path = thumbnail?.path, let ext = thumbnail?.ext else {
            return nil
        }
        return "\(path).\(ext)"
    }
    
    init(from result: CharacterMediaResult) {
        self.id = result.id ?? 0
        self.name = result.title ?? "Unknown"
        self.thumbnail = result.thumbnail
    }
}
