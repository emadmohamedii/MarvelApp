//
//  Hash.swift
//  Core
//
//  Created by Emad Habib on 08/11/2024.
//

import CryptoKit
import Foundation

final class HashGenerator {
    class func getCredentials(networkConfig: NetworkLayerConfigProtocol) -> String {
        let ts = String(Int(Date().timeIntervalSince1970 * 1000))
        let hash = md5Hash("\(ts)\(networkConfig.privateApiKey)\(networkConfig.publicApiKey)")
        return "?ts=\(ts)&apikey=\(networkConfig.publicApiKey)&hash=\(hash)"
    }
}

fileprivate func md5Hash(_ source: String) -> String {
    return Insecure.MD5.hash(data: source.data(using: .utf8)!).map { String(format: "%02hhx", $0) }.joined()
}
