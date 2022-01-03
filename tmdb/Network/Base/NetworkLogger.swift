//
//  NetworkLogger.swift
//  tmdb
//
//  Created by Adem Özsayın on 1/2/22.
//

import Foundation

class NetworkLogger {
    static func log(request: URLRequest) {
        
        #if DEBUG
            print("\n - - - - - - - - - - OUTGOING - - - - - - - - - - \n")
            defer { print("\n - - - - - - - - - -  END - - - - - - - - - - \n") }
        #endif
        
        let urlAsString = request.url?.absoluteString ?? ""
        let urlComponents = NSURLComponents(string: urlAsString)
        
        let method = request.httpMethod != nil ? "\(request.httpMethod ?? "")" : ""
        let path = "\(urlComponents?.path ?? "")"
        let query = "\(urlComponents?.query ?? "")"
        let host = "\(urlComponents?.host ?? "")"
        
        var logOutput = """
                        \(urlAsString) \n\n
                        \(method) \(path)?\(query) HTTP/1.1 \n
                        HOST: \(host)\n
                        """
        for (key,value) in request.allHTTPHeaderFields ?? [:] {
            logOutput += "\(key): \(value) \n"
        }
        if let body = request.httpBody {
            logOutput += "\n \(NSString(data: body, encoding: String.Encoding.utf8.rawValue) ?? "")"
        }
        #if DEBUG
            print(logOutput)
        #endif
        
    }
    
    static func log(response: URLResponse) {}
}

