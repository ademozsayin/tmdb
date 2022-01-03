//
//  Configuration.swift
//  tmdb
//
//  Created by Adem Özsayın on 1/2/22.
//

import Foundation

enum Configuration: String {

    // MARK: - Configurations

    case development
    case release

    // MARK: - Current Configuration

    static let current: Configuration = {
        guard let rawValue = Bundle.main.infoDictionary?["Configuration"] as? String else {
            fatalError("No Configuration Found")
        }

        guard let configuration = Configuration(rawValue: rawValue.lowercased()) else {
            fatalError("Invalid Configuration")
        }

        return configuration
    }()

    // MARK: - Base URL

    static var baseURL: String {
        return "https://api.themoviedb.org/3/"
    }
    
    static var apiKey: String {
        return "a753005191492272e6cba3584d4b2fde"
    }

}
