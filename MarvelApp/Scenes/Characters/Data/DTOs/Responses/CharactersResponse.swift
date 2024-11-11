//
//  CharactersResponse.swift
//  MarvelApp
//
//  Created by Emad Habib on 08/11/2024.
//
import Foundation

struct CharactersResponse : Codable {
    let data : CharactersData?
}

struct CharactersData : Codable {
    let results : [CharactersResult]?
}

struct CharactersResult : Codable {
    let descriptionField : String?
    let id : Int?
    let name : String?
    let thumbnail : CharactersThumbnail?
    enum CodingKeys: String, CodingKey {
        case descriptionField = "description"
        case id = "id"
        case name = "name"
        case thumbnail
    }
}

struct CharactersThumbnail : Codable {
    let ext : String?
    let path : String?
    enum CodingKeys: String, CodingKey {
        case ext = "extension"
        case path = "path"
    }
}
