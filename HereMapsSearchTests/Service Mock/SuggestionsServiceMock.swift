//
//  SuggestionsServiceManager.swift
//  HereMapsSearchTests
//
//  Created by Garcia, Bruno (B.C.) on 01/09/19.
//  Copyright © 2019 Garcia, Bruno (B.C.). All rights reserved.
//

import Foundation
@testable import HereMapsSearch

class SuggestionsServiceMock: SuggestionsServiceProtocol {
    
    var completeClosureFetchSuggestions: ((SuggestionsResponse?, RequestError?) -> ())!
    
    func fetchSuggestions(query: String, prox: String, completion: @escaping (SuggestionsResponse?, RequestError?) -> ()) {
        completeClosureFetchSuggestions = completion
    }
    
    // Mocking Success
    func fetchSuccess() {
        completeClosureFetchSuggestions( MockDataHelper.getAutocompleteMock(), nil )
    }
    
    //Mocking Error
    func fetchFail(error: RequestError?) {
        completeClosureFetchSuggestions( nil, error )
    }
    
}
