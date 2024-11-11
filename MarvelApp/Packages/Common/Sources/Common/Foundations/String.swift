//
//  String.swift
//  Common
//
//  Created by Emad Habib on 08/11/2024.
//

public extension String {
    var isNotNullOrEmpty: Bool {
        return self.isEmpty == false
    }
}

public extension Optional where Wrapped == String {
    var isNotNullOrEmpty: Bool {
        return self?.isEmpty == false
    }
}
