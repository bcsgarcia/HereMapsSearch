//
//  SuggestionsService.swift
//  HereMapsSearch
//
//  Created by Bruno Garcia on 27/08/19.
//  Copyright © 2019 Garcia, Bruno (B.C.). All rights reserved.
//

import Foundation
import Alamofire

protocol SuggestionsServiceProtocol {
    func fetchSuggestions(query: String, prox: String, completion: @escaping (SuggestionsResponse?, RequestError?) -> ())
}

class SuggestionsService : SuggestionsServiceProtocol {
    func fetchSuggestions(query: String, prox: String, completion: @escaping (SuggestionsResponse?, RequestError?) -> ()) {
        Alamofire.request(UrlRouter.getSuggestions(query, prox))
            .responseJSON { (response) in
                if response.result.value == nil {
                    completion(nil, .noResponse)
                    return
                }
                guard let data = response.data else {
                    completion(nil, .noData)
                    return
                }
                
                do {
                    let response = try JSONDecoder().decode(SuggestionsResponse.self, from: data)
                    DispatchQueue.main.async {
                        completion(response, nil)
                    }
                } catch let jsonErr {
                    print("Failed to decode:", jsonErr)
                    completion(nil, .invalidJSON)
                }
        }
    }
}

