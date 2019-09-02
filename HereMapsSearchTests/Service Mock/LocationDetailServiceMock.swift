//
//  LocationDetailServiceMock.swift
//  HereMapsSearchTests
//
//  Created by Garcia, Bruno (B.C.) on 02/09/19.
//  Copyright © 2019 Garcia, Bruno (B.C.). All rights reserved.
//

import Foundation
@testable import HereMapsSearch

class LocationDetailServiceMock: LocationDetailServiceProtocol {
    
    var completeClosureFetchLocation: ((Location?, RequestError?) -> ())!
    
    func fetchLocation(locationId: String, completion: @escaping (Location?, RequestError?) -> ()) {
        completeClosureFetchLocation = completion
    }
    
    // Mocking Success
    func fetchSuccess() {
        
        let locationResponse = MockDataHelper.getGeocoderMock()
        
        guard let responseView = locationResponse.response else {
            completeClosureFetchLocation(nil, .noData)
            return
        }
        
        guard let viewR = responseView.view else {
            completeClosureFetchLocation(nil, .noData)
            return
        }
        
        if viewR.count == 0 {
            completeClosureFetchLocation(nil, .noData)
            return
        }
        
        guard let locationArr = viewR[0].result else {
            completeClosureFetchLocation(nil, .noData)
            return
        }
        
        if locationArr.count == 0 {
            completeClosureFetchLocation(nil, .noData)
            return
        }
        
        if let location = locationArr[0].location {
            completeClosureFetchLocation(location, nil)
        } else {
            completeClosureFetchLocation(nil, .noData)
        }
        
    }
    
    //Mocking Error
    func fetchFail(error: RequestError?) {
        completeClosureFetchLocation( nil, error )
    }
    
}
