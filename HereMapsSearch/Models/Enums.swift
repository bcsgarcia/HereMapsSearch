//
//  Enums.swift
//  HereMapsSearch
//
//  Created by Bruno Garcia on 27/08/19.
//  Copyright © 2019 Garcia, Bruno (B.C.). All rights reserved.
//

import Foundation
import Alamofire

enum RequestError {
    case invalidJSON
    case url
    case noResponse
    case noData
    case noInternetConnection
    case httpError(code: Int)
}

enum UrlRouter: URLRequestConvertible {
    static let baseURLString = Config.sharedInstance.AUTO_COMPLETE_GEOCODER_URL
    
    case getSuggestions(String,String)
    
    func asURLRequest() throws -> URLRequest {
        var method: HTTPMethod {
            switch self {
            case .getSuggestions:
                return .get
            }
        }
        
        let url: URL = {
            // build up and return the URL for each endpoint
            let relativePath: String?
            
            switch self {
            case .getSuggestions(let label, let proxLocation ):
                relativePath = "?app_id=\(Config.sharedInstance.APP_ID)&app_code=\(Config.sharedInstance.APP_CODE)&query=\(label.replacingOccurrences(of: " ", with: "+"))&prox=\(proxLocation)&maxresults=15"
            }
            
            var url = URL(string: UrlRouter.baseURLString)!
            if let relativePath = relativePath {
                url = URL(string: UrlRouter.baseURLString + relativePath)!
                print(url)
            }
            
            return url
        }()
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        
        let encoding: ParameterEncoding = {
            switch method {
            case .get:
                return URLEncoding.default
            default:
                return JSONEncoding.default
            }
        }()
        return try encoding.encode(urlRequest, with: nil)
        
    }
}
