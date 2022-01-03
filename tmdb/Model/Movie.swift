//
//  Movie.swift
//  tmdb
//
//  Created by Adem Özsayın on 1/2/22.
//

import Foundation

struct Movie: Codable {
    var adult: Bool?
    var backdropPath: String?
    var genreIDS: [Int]?
    var id: Int?
    var originalLanguage, originalTitle, overview: String?
    var popularity: Double?
    var posterPath, releaseDate, title: String?
    var video: Bool?
    var voteAverage: Double?
    var voteCount: Int?
    var imdbId:String?

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genreIDS = "genre_ids"
        case id
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case imdbId = "imdb_id"
    }
    
    func niceTitle() -> String {
        var niceTitle = ""
        if let title = title {
            niceTitle = title
            if let releaseDate = releaseDate, let date = releaseDate.toDate()  {
                let year = date.yearAsString()
                niceTitle = niceTitle + " " + "(" + year + ")"
            }
        }
        
        return niceTitle
    }
}
