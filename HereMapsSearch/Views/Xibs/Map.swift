//
//  MapView.swift
//  HereMapsSearch
//
//  Created by Garcia, Bruno (B.C.) on 29/08/19.
//  Copyright © 2019 Garcia, Bruno (B.C.). All rights reserved.
//

import Foundation
import NMAKit

class Map {
    
    static let mapView = NMAMapView()
    private static var mapCircle : NMAMapCircle? = nil
    
    static func setMapPosition(with currentCoordinate: Position) {
        mapView.useHighResolutionMap = true
        mapView.zoomLevel = 14.2
        
        let coordinates = NMAGeoCoordinates(latitude: currentCoordinate.latitude ?? 0.0, longitude: currentCoordinate.longitude ?? 0.0)
        mapView.set(geoCenter: coordinates, animation: .linear)
        mapView.copyrightLogoPosition = NMALayoutPosition.bottomCenter
        addMapCircle(coordinates)
    }
    
    static func addMapCircle(_ coordinates: NMAGeoCoordinates) {
        if mapCircle != nil {
            mapView.remove(mapCircle!)
        }
        
        mapCircle = NMAMapCircle(coordinates: coordinates, radius: 50)
        mapCircle!.fillColor = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1)
        mapCircle!.lineWidth = 2
        mapCircle!.lineColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        mapView.add(mapCircle!)
    }
    
    
    
}
