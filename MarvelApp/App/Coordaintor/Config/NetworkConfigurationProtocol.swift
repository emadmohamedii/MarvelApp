//
//  AppConfigurationProtocol.swift
//  CommonUI
//
//  Created by Emad Habib on 07/11/2024.
//

import Foundation

public protocol NetworkConfigurationProtocol {
  var apiKey: String { get set }
  var apiBaseURL: URL { get set }
}
