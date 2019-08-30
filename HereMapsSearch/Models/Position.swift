//
//  Position.swift
//  HereMapsSearch
//
//  Created by Garcia, Bruno (B.C.) on 28/08/19.
//  Copyright © 2019 Garcia, Bruno (B.C.). All rights reserved.
//

import Foundation

class Position: Codable {
    
    var latitude: Double? = 0.0
    var longitude: Double? = 0.0
    
    
    init(){}
    
    init(with favorite: Favorite) {
        self.latitude = favorite.latitude
        self.longitude = favorite.longitude
    }
    
    func getProxString() -> String {
        return "\(self.latitude ?? 0.0),\(self.longitude ?? 0.0),500"
    }
    
    func toString() -> String {
        return "\(self.latitude ?? 0.0),\(self.longitude ?? 0.0)"
    }
}
