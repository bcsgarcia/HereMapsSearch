//
//  DetailViewModel.swift
//  HereMapsSearch
//
//  Created by Garcia, Bruno (B.C.) on 28/08/19.
//  Copyright © 2019 Garcia, Bruno (B.C.). All rights reserved.
//

import Foundation
import NMAKit

class DetailViewModel: BaseViewModel {
    
    var location: Location? {
        didSet {
            self.isLoading = false
            self.didFinishFetch?()
        }
    }
    
    let service : LocationDetailServiceProtocol
    
    //Dependency Injection
    init(service: LocationDetailServiceProtocol = LocationDetailService()) {
        self.service = service
    }
    
    func fetchData(_ locationId: String) {
        self.isLoading = true
        
        if !CheckInternet.Connection() {
            self.error = .noInternetConnection
            return
        }
        
        service.fetchLocation(locationId: locationId) { (location, error) in
            
            if let error = error {
                self.error = error
                return
            }
            
            guard let location = location else {
                self.error = .messageError(message: "no locarion found")
                return
            }
            
            self.location = location
        }
        
    }
    
   
    
    
}
