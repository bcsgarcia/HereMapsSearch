//
//  LocationDetailService.swift
//  HereMapsSearch
//
//  Created by Garcia, Bruno (B.C.) on 28/08/19.
//  Copyright © 2019 Garcia, Bruno (B.C.). All rights reserved.
//

import Foundation
import Alamofire

protocol LocationDetailServiceProtocol {
    func fetchLocation(locationId: String, completion: @escaping (Location?, RequestError?) -> ())
}

class LocationDetailService : LocationDetailServiceProtocol {
    
    func fetchLocation(locationId: String, completion: @escaping (Location?, RequestError?) -> ()) {
        
        Alamofire.request(UrlRouter.getLocationDetail(locationId))
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
                    let locationResponse = try JSONDecoder().decode(LocationResponse.self, from: data)
                    
                        guard let responseView = locationResponse.response else {
                            completion(nil, .noData)
                            return
                        }
                        
                        guard let viewR = responseView.view else {
                            completion(nil, .noData)
                            return
                        }
                        
                        if viewR.count == 0 {
                            completion(nil, .noData)
                            return
                        }
                        
                        guard let location = viewR[0].result else {
                            completion(nil, .noData)
                            return
                        }
                        
                        if location.count == 0 {
                            completion(nil, .noData)
                            return
                        }
                        
                        completion(location[0].location, nil)
                    
                } catch let jsonErr {
                    print("Failed to decode:", jsonErr)
                    completion(nil, .invalidJSON)
                }
        }
    }
    
}
