//
//  Array.swift
//  Common
//
//  Created by Emad Habib on 08/11/2024.
//

public extension Array {
    var isNotEmpty: Bool {
        isEmpty == false
    }
}

public extension Array {
    /// Subscript that returns nil instead of crashing when accessing an out-of-bounds index.
    subscript(safe index: Int) -> Element? {
        get {
            return indices ~= index ? self[index] : nil
        }
        set {
            if let newValue = newValue, indices ~= index {
                self[index] = newValue
            }
        }
    }
}
