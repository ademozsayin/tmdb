//
//  GenericResponse.swift
//  tmdb
//
//  Created by Adem Özsayın on 1/2/22.
//

import Foundation


struct GenericResponse<T: Codable>: Codable {

    // MARK: - Properties
    var page:Int?
    var totalResults: Int?
    var totalPages: Int?
    var data: T?
    
    private enum CodingKeys: String, CodingKey {
        case page
        case totalResults = "total_results"
        case totalPages = "total_pages"
        case data = "results"
    }

    public init(from decoder: Decoder) throws {
        let keyedContainer = try decoder.container(keyedBy: CodingKeys.self)
        page = (try? keyedContainer.decode(Int.self, forKey: CodingKeys.page)) ?? 1
        totalResults = (try? keyedContainer.decode(Int.self, forKey: CodingKeys.totalResults)) ?? 0
        totalPages = (try? keyedContainer.decode(Int.self, forKey: CodingKeys.totalPages)) ?? 1
        data = try? keyedContainer.decode(T.self, forKey: CodingKeys.data)
    }
}

struct ErrorResponse<T: Codable>: Codable {

    // MARK: - Properties
    
    var status_code:Int?
    var status_message:String?
    var success:Bool?
    
    
}



