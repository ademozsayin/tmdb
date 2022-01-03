//
//  Task.swift
//  tmdb
//
//  Created by Adem Özsayın on 1/2/22.
//

import Foundation
import Alamofire

public enum Task {

    /// A request with no additional data.
    case requestPlain

    /// A requests body set with encoded parameters.
    case requestParameters(parameters: [String: Any], encoding: ParameterEncoding)

}
