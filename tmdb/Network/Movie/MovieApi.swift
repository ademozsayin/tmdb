//
//  MovieApi.swift
//  tmdb
//
//  Created by Adem Özsayın on 1/2/22.
//

import Foundation

protocol MovieAPIProtocol {
    func upcoming(completionHandler: @escaping (Result< GenericResponse<[Movie]>, NSError>) -> Void)
    func nowPlaying(completionHandler: @escaping (Result< GenericResponse<[Movie]>, NSError>) -> Void)
    func getMovieDetail(id:Int,completionHandler: @escaping (Result<Movie,NSError >) -> Void)

}

class MovieAPI: BaseAPI<MovieNetworking>, MovieAPIProtocol {
    func upcoming(completionHandler: @escaping (Result<GenericResponse<[Movie]>, NSError>) -> Void) {
        self.fetchData(target: .upcoming, responseClass: [Movie].self) { result  in
            completionHandler(result)
        }
    }
    
    func nowPlaying(completionHandler: @escaping (Result<GenericResponse<[Movie]>, NSError>) -> Void) {
        self.fetchData(target: .upcoming, responseClass: [Movie].self) { result  in
            completionHandler(result)
        }
    }
    
    func getMovieDetail(id:Int,completionHandler: @escaping (Result<Movie,NSError> ) -> Void) {
        self.sendRequest(target: .movieDetail(id: id), responseClass: Movie.self) { result  in
            completionHandler(result)
        }
    }
    
    
}
