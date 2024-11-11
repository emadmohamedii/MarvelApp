//
//  MediaRequest.swift
//  MarvelApp
//
//  Created by Emad Habib on 09/11/2024.
//

enum MediaType: String, CaseIterable, Encodable, Equatable {
    case comics
    case series
    case stories
    case events
    
    var title: String {
        switch self {
        case .comics: return "Comics"
        case .series: return "Series"
        case .stories: return "Stories"
        case .events: return "Events"
        }
    }
    
    var sectionType: CharDetailSectionType {
        switch self {
        case .comics:
            return .comics
        case .series:
            return .series
        case .stories:
            return .stories
        case .events:
            return .events
        }
    }
}

struct MediaRequest: Encodable{
    let charId: Int
    let mediaType: MediaType
}
