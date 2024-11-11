//
//  CharactersRequest.swift
//  MarvelApp
//
//  Created by Emad Habib on 08/11/2024.
//
import Foundation

struct CharactersRequest: Encodable {
    let limit: Int
    let offset: Int
    let name: String?
    
    init(limit: Int = 10, offset: Int = 0, name: String? = nil) {
        self.limit = limit
        self.offset = offset
        self.name = name
    }
}
