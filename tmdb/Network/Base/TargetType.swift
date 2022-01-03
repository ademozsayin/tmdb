//
//  TargetType.swift
//  tmdb
//
//  Created by Adem Özsayın on 1/2/22.
//

import Foundation

protocol TargetType {
    
    var baseURL: String {get}

    var task: Task {get}

    var headers: [String: String]? {get}
    
    var path: String { get }
    
    var method: HTTPMethod { get }
}
