//
//  BaseAPI.swift
//  tmdb
//
//  Created by Adem Özsayın on 1/2/22.
//

import Foundation
import Alamofire

enum NetworkResponse:String {
    case success
    case authenticationError = "You need to be authenticated first."
    case badRequest = "Bad request"
    case outdated = "The url you requested is outdated."
    case failed = "Network request failed."
    case noData = "Response returned with no data to decode."
    case unableToDecode = "We could not decode the response."
}

enum CustomResult<String>{
    case success
    case failure(String)
}

class BaseAPI<T:TargetType> {

    func fetchData<M: Decodable>(target: T, responseClass: M.Type, completionHandler:@escaping (Result<GenericResponse<M>, NSError>)-> Void) {
        
        let method = Alamofire.HTTPMethod(rawValue: target.method.rawValue)
        let headers = Alamofire.HTTPHeaders(target.headers ?? [:])
        let parameters = buildParams(task: target.task)

        AF.request(target.baseURL + target.path, method: method, parameters: parameters.0, encoding: parameters.1, headers: headers).responseJSON { (response) in


            guard let request = response.request else { return }
            NetworkLogger.log(request:request)

            guard let statusCode = response.response?.statusCode else {
                print("StatusCode not found")
                completionHandler(.failure(NSError()))
                return
            }

            if statusCode == 200 {

                guard let jsonResponse = try? response.result.get() else {
                    print("jsonResponse error")
                    completionHandler(.failure(NSError()))
                    return
                }
//                print(jsonResponse)

                guard let theJSONData = try? JSONSerialization.data(withJSONObject: jsonResponse, options: []) else {
                    print("theJSONData error")
                    completionHandler(.failure(NSError()))
                    return
                }

                guard let responseObj = try? JSONDecoder().decode(GenericResponse<M>.self, from: theJSONData) else {
                    print("responseObj error")
                    completionHandler(.failure(NSError()))
                    return
                }
                completionHandler(.success(responseObj))


            } else {
                print("error statusCode is \(statusCode)")
                completionHandler(.failure(NSError()))

            }
        }
    }
    
    
    func sendRequest<M: Decodable>(target: T, responseClass: M.Type, completionHandler:@escaping (Result<Movie,NSError>)-> Void) {
        
        let method = Alamofire.HTTPMethod(rawValue: target.method.rawValue)
        let headers = Alamofire.HTTPHeaders(target.headers ?? [:])
        let parameters = buildParams(task: target.task)

        AF.request(target.baseURL + target.path, method: method, parameters: parameters.0, encoding: parameters.1, headers: headers).responseJSON { (response) in


            guard let request = response.request else { return }
            NetworkLogger.log(request:request)

            guard let statusCode = response.response?.statusCode else {
                print("StatusCode not found")
                completionHandler(.failure(NSError()))
                return
            }

            if statusCode == 200 {

                guard let jsonResponse = try? response.result.get() else {
                    print("jsonResponse error")
                    completionHandler(.failure(NSError()))
                    return
                }
                print(jsonResponse)

                guard let theJSONData = try? JSONSerialization.data(withJSONObject: jsonResponse, options: []) else {
                    print("theJSONData error")
                    completionHandler(.failure(NSError()))
                    return
                }

                guard let responseObj = try? JSONDecoder().decode(Movie.self, from: theJSONData) else {
                    print("responseObj error")
                    completionHandler(.failure(NSError()))
                    return
                }
                completionHandler(.success(responseObj))


            } else {
                print("error statusCode is \(statusCode)")
                completionHandler(.failure(NSError()))

            }
        }
    }
    

    private func buildParams(task: Task) -> ([String: Any], ParameterEncoding){


        switch task {
        case .requestPlain:

            return ([:], URLEncoding.default)
        case .requestParameters(parameters: let parameters, encoding: let encoding):
            return (parameters, encoding)

        }

    }

    fileprivate func handleNetworkResponse(_ response: HTTPURLResponse) -> CustomResult<String>{
        switch response.statusCode {
        case 200...299: return .success
        case 401...500: return .failure(NetworkResponse.authenticationError.rawValue)
        case 501...599: return .failure(NetworkResponse.badRequest.rawValue)
        case 600: return .failure(NetworkResponse.outdated.rawValue)
        default: return .failure(NetworkResponse.failed.rawValue)
        }
    }


}


