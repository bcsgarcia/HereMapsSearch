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
    
    var didFinishFetchImage: (() -> ())?
    
    var locationImage: UIImage? {
        didSet {
            self.isLoading = false
            self.didFinishFetchImage?()
        }
    }
    
    let locationService : LocationDetailServiceProtocol
    let imageService : ImageServiceProtocol
    
    //Dependency Injection
    init(locationService: LocationDetailServiceProtocol = LocationDetailService(), imageService: ImageServiceProtocol = ImageService()) {
        self.locationService = locationService
        self.imageService = imageService
    }
    
    func fetchData(_ locationId: String) {
        self.isLoading = true
        
        if !CheckInternet.Connection() {
            self.error = .noInternetConnection
            return
        }
        
        locationService.fetchLocation(locationId: locationId) { (location, error) in
            
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
    
    func fetchImage(_ coordinates: String) {
        self.isLoading = true
        
        if !CheckInternet.Connection() {
            self.error = .noInternetConnection
            return
        }
        
        imageService.fetchImageData(coordinates: coordinates) { (image) in
            if let image = image {
                self.locationImage = image
            } else {
                self.locationImage = nil
            }
        }
    }
}
