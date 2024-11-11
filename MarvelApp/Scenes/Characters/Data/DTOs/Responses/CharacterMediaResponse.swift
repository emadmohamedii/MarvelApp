//
//  CharacterMediaResponse.swift
//  MarvelApp
//
//  Created by Emad Habib on 11/11/2024.
//

import Foundation

struct CharacterMediaResponse : Codable {
    let data : CharacterMediaData?
}

struct CharacterMediaData : Codable {
    let results : [CharacterMediaResult]?
}

struct CharacterMediaResult : Codable {
    let thumbnail : CharactersThumbnail?
    let title : String?
    let id : Int?
}
