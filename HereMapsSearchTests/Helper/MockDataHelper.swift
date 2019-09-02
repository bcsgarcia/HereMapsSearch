//
//  MockDataHelper.swift
//  HereMapsSearchTests
//
//  Created by Garcia, Bruno (B.C.) on 01/09/19.
//  Copyright © 2019 Garcia, Bruno (B.C.). All rights reserved.
//

import Foundation
import UIKit
@testable import HereMapsSearch

class MockDataHelper {
    
    class func getAutocompleteMock() -> SuggestionsResponse {
        do {
            guard let asset = NSDataAsset(name: "autocomplete", bundle: Bundle.main) else { return SuggestionsResponse() }
            let response = try JSONDecoder().decode(SuggestionsResponse.self, from: asset.data)
            return response
        } catch let jsonErr {
            print("Failed to decode:", jsonErr)
            return SuggestionsResponse()
        }
    }
    
    class func getGeocoderMock() -> LocationResponse {
        do {
            guard let asset = NSDataAsset(name: "geocoder", bundle: Bundle.main) else { return LocationResponse() }
            let response = try JSONDecoder().decode(LocationResponse.self, from: asset.data)
            return response
        } catch let jsonErr {
            print("Failed to decode:", jsonErr)
            return LocationResponse()
        }
    }
    
    class func getImageMock() -> UIImage? {
        return UIImage(named: "imageMock")
    }
    
    
}
