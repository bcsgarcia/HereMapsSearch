//
//  Location.swift
//  HereMapsSearch
//
//  Created by Garcia, Bruno (B.C.) on 28/08/19.
//  Copyright © 2019 Garcia, Bruno (B.C.). All rights reserved.
//

import Foundation

class Location: Codable {
    var locationId: String? = ""
    var locationType: String? = ""
    var displayPosition: Position? = Position()
    var navigationPosition: [Position]? = []
    var address: Address? = Address()
}

class LocationResponse: Codable{
    var response: ResponseView? = ResponseView()
}

class ResponseView: Codable {
    var view: [ViewResult]? = []
}

class ViewResult: Codable {
    var result: [ResultLocation]? = []
}

class ResultLocation: Codable {
    var location: Location?
}
    /*
    {
        "response": {
            "metaInfo": {
                "timestamp": "2019-08-28T17:32:33.690+0000"
            },
            "view": [
            {
            "result": [
            {
            "relevance": 0.0,
            "matchLevel": "houseNumber",
            "matchType": "pointAddress",
            "location": {
            "locationId": "NT_5mGkj3z90Fbj4abzMbUE4C_xA",
            "locationType": "address",
            "displayPosition": {
            "latitude": 52.51587,
            "longitude": 13.37803
            },
            "navigationPosition": [
            {
            "latitude": 52.51589,
            "longitude": 13.37828
            }
            ],
            "mapView": {
            "topLeft": {
            "latitude": 52.5169942,
            "longitude": 13.3761827
            },
            "bottomRight": {
            "latitude": 52.5147458,
            "longitude": 13.3798773
            }
            },
            "address": {
            "label": "Pariser Platz 1, 10117 Berlin, Deutschland",
            "country": "DEU",
            "state": "Berlin",
            "county": "Berlin",
            "city": "Berlin",
            "district": "Mitte",
            "street": "Pariser Platz",
            "houseNumber": "1",
            "postalCode": "10117",
            "additionalData": [
            {
            "value": "Deutschland",
            "key": "CountryName"
            },
            {
            "value": "Berlin",
            "key": "StateName"
            },
            {
            "value": "Berlin",
            "key": "CountyName"
            }
            ]
            }
            }
            }
            ],
            "viewId": 0
            }
            ]
        }
    }
 */

