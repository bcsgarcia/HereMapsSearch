//
//  Config.swift
//  HereMapsSearch
//
//  Created by Bruno Garcia on 27/08/19.
//  Copyright © 2019 Garcia, Bruno (B.C.). All rights reserved.
//

import Foundation
import NMAKit

class Config {
    
    static let sharedInstance = Config()
    
    let APP_ID = "oaF2VxsY5r05iFUshalJ"
    let APP_CODE = "2s6K8A1mASnWqJ6OXVmEEA"
    let AUTO_COMPLETE_GEOCODER_URL = "https://autocomplete.geocoder.api.here.com/6.2/suggest.json"
    let GEOCODER_DETAIL_URL = "https://geocoder.api.here.com/6.2/geocode.json"
    let IMAGE_URL = "https://image.maps.api.here.com/mia/1.6/mapview"
}
