//
//  Address.swift
//  HereMapsSearch
//
//  Created by Garcia, Bruno (B.C.) on 27/08/19.
//  Copyright © 2019 Garcia, Bruno (B.C.). All rights reserved.
//

import Foundation

class Address: Codable {
    /* Suggestion
     "address": {
         "country": "Brasil",
         "state": "São Paulo",
         "city": "Diadema",
         "district": "Casa Grande",
         "street": "Rua Rio de Janeiro",
         "postalCode": "09961-730"
     },
    */
    
    var country: String? = ""
    var state: String? = ""
    var city: String? = ""
    var district: String? = ""
    var street: String? = ""
    var postalCode: String? = ""
    
    /* Location Detail
     "label": "Pariser Platz 1, 10117 Berlin, Deutschland",
     "country": "DEU",
     "state": "Berlin",
     "county": "Berlin",
     "city": "Berlin",
     "district": "Mitte",
     "street": "Pariser Platz",
     "houseNumber": "1",
     "postalCode": "10117",
    */
    
    var label: String? = ""
    var county: String? = ""
    var houseNumber: String? = ""
    
}
