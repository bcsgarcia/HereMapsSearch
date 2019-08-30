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
    case messageError(message: String)
    case httpError(code: Int)
}

enum UrlRouter: URLRequestConvertible {
    
    
    case getSuggestions(String,String)
    case getLocationDetail(String)
    case getImage(String)
    
    func asURLRequest() throws -> URLRequest {
        var method: HTTPMethod {
            switch self {
            case .getSuggestions, .getLocationDetail, .getImage:
                return .get
            }
        }
        
        let url: URL = {
            // build up and return the URL for each endpoint
            let relativePath: String
            let baseURLString: String
            let url: URL
            
            switch self {
            case .getSuggestions(let label, let proxLocation ):
                baseURLString = Config.sharedInstance.AUTO_COMPLETE_GEOCODER_URL
                relativePath = "?app_id=\(Config.sharedInstance.APP_ID)&app_code=\(Config.sharedInstance.APP_CODE)&query=\(label.replacingOccurrences(of: " ", with: "+"))&prox=\(proxLocation)&maxresults=15"
                break
            case .getLocationDetail(let locationId):
                baseURLString = Config.sharedInstance.GEOCODER_DETAIL_URL
                relativePath = "?app_id=\(Config.sharedInstance.APP_ID)&app_code=\(Config.sharedInstance.APP_CODE)&jsonattributes=1&gen=9&locationid=\(locationId)"
                break
            case .getImage(let coordinates):
                baseURLString = Config.sharedInstance.IMAGE_URL
                relativePath = "?app_id=\(Config.sharedInstance.APP_ID)&app_code=\(Config.sharedInstance.APP_CODE)&c=\(coordinates)&u=1k&h=300&w=420"
                print(baseURLString + relativePath)
                break
            }
            
            url = URL(string: baseURLString + relativePath)!
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
