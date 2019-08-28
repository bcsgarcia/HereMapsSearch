//
//  Suggestion.swift
//  HereMapsSearch
//
//  Created by Garcia, Bruno (B.C.) on 27/08/19.
//  Copyright © 2019 Garcia, Bruno (B.C.). All rights reserved.
//

import Foundation


class Suggestion: Codable {
    /*
     "label": "Brasil, Diadema, Casa Grande, Rua Rio de Janeiro",
     "language": "pt",
     "countryCode": "BRA",
     "locationId": "NT_K.OyvaYnM33hFKp2fN5yDA",
     "address": {
         "country": "Brasil",
         "state": "São Paulo",
         "city": "Diadema",
         "district": "Casa Grande",
         "street": "Rua Rio de Janeiro",
         "postalCode": "09961-730"
     },
     "distance": 7262,
     "matchLevel": "street"
    */
    
    var label: String? = ""
    var language: String? = ""
    var countryCode: String? = ""
    var locationId: String? = ""
    var distance: Int? = 0
    var matchLevel: String? = ""
    var address = Address()
    
}

class SuggestionsResponse: Codable {
    var suggestions: [Suggestion]? = []
}
