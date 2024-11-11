//
//  CharactersResponse.swift
//  MarvelApp
//
//  Created by Emad Habib on 08/11/2024.
//
import Foundation

struct CharactersResponse : Codable {
    
    let attributionHTML : String?
    let attributionText : String?
    let code : Int?
    let copyright : String?
    let data : CharactersData?
    let etag : String?
    let status : String?
    
    enum CodingKeys: String, CodingKey {
        case attributionHTML = "attributionHTML"
        case attributionText = "attributionText"
        case code = "code"
        case copyright = "copyright"
        case data
        case etag = "etag"
        case status = "status"
    }
}

struct CharactersData : Codable {
    
    let count : Int?
    let limit : Int?
    let offset : Int?
    let results : [CharactersResult]?
    let total : Int?
    
    enum CodingKeys: String, CodingKey {
        case count = "count"
        case limit = "limit"
        case offset = "offset"
        case results = "results"
        case total = "total"
    }
}

struct CharactersResult : Codable {
    
    let comics : CharactersComic?
    let descriptionField : String?
    let events : CharactersComic?
    let id : Int?
    let modified : String?
    let name : String?
    let resourceURI : String?
    let series : CharactersComic?
    let stories : CharactersComic?
    let thumbnail : CharactersThumbnail?
    let urls : [CharactersUrl]?
    
    enum CodingKeys: String, CodingKey {
        case comics
        case descriptionField = "description"
        case events
        case id = "id"
        case modified = "modified"
        case name = "name"
        case resourceURI = "resourceURI"
        case series
        case stories
        case thumbnail
        case urls = "urls"
    }
}

struct CharactersUrl : Codable {
    
    let type : String?
    let url : String?
    
    enum CodingKeys: String, CodingKey {
        case type = "type"
        case url = "url"
    }
}

struct CharactersThumbnail : Codable {
    
    let ext : String?
    let path : String?
    var fullImage :String?

    enum CodingKeys: String, CodingKey {
        case ext = "extension"
        case path = "path"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        ext = try values.decodeIfPresent(String.self, forKey: .ext)
        path = try values.decodeIfPresent(String.self, forKey: .path)
        if let path = path , let ext = ext {
            fullImage = path + "." + ext
        }
    }
}

struct CharactersComic : Codable {
    
    let available : Int?
    let collectionURI : String?
    let items : [CharactersItem]?
    let returned : Int?
    
    enum CodingKeys: String, CodingKey {
        case available = "available"
        case collectionURI = "collectionURI"
        case items = "items"
        case returned = "returned"
    }
}

struct CharactersItem : Codable {
    
    let name : String?
    let resourceURI : String?
    let type : String?
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case resourceURI = "resourceURI"
        case type = "type"
    }
}
