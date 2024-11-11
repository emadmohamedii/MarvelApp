//
//  CharacterDetailDataSource.swift
//  MApp
//
//  Created by Emad Habib on 16/09/2023.
//
import Foundation

struct CharDetailSectionOfCustomData {
    var headerType: CharDetailSectionType
    var header: String = ""
    var items: [CharDetailSection] = []
    var loading: Bool = false
}

enum CharDetailSectionType: Int {
    case header
    case comics
    case series
    case stories
    case events
    case relatedLinks
}

struct CharDetailSection {
    var name: String?
    var id: Int?
    var image: String?
    var desc: String?
    var type: CharDetailSectionType
    var comics: [CharacterMediaModel]? = nil
    var events: [CharacterMediaModel]? = nil
    var stories: [CharacterMediaModel]? = nil
    var series: [CharacterMediaModel]? = nil
}
