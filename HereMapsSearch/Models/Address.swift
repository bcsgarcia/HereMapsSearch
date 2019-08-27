//
//  Address.swift
//  HereMapsSearch
//
//  Created by Garcia, Bruno (B.C.) on 27/08/19.
//  Copyright © 2019 Garcia, Bruno (B.C.). All rights reserved.
//

import Foundation

class Address: Codable {
    /*
     "address": {
         "country": "Brasil",
         "state": "São Paulo",
         "city": "Diadema",
         "district": "Casa Grande",
         "street": "Rua Rio de Janeiro",
         "postalCode": "09961-730"
     },
    */
    
    var country: String = ""
    var state: String = ""
    var city: String = ""
    var district: String = ""
    var street: String = ""
    var postalCode: String = ""
    
}
