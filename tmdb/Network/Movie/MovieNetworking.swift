//
//  MovieNetworking.swift
//  tmdb
//
//  Created by Adem Özsayın on 1/2/22.
//

import Foundation
import Alamofire

enum MovieNetworking {
    case upcoming
    case nowPlaying
    case movieDetail(id:Int)
}

extension MovieNetworking: TargetType {
    
    var baseURL: String {
       return Configuration.baseURL
    }
    
    var path: String {
        switch self {
        case .upcoming:
            return "movie/upcoming?api_key=\(Configuration.apiKey)"
        case .nowPlaying:
            return "movie/upcoming?api_key=\(Configuration.apiKey)"
        case .movieDetail(let id):
            return "movie/\(id)?api_key=\(Configuration.apiKey)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .upcoming, .nowPlaying, .movieDetail:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .upcoming, .nowPlaying, .movieDetail:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
        default:
            return [:]
        }
    }
    
}


