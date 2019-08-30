//
//  MapView.swift
//  HereMapsSearch
//
//  Created by Garcia, Bruno (B.C.) on 29/08/19.
//  Copyright © 2019 Garcia, Bruno (B.C.). All rights reserved.
//

import Foundation
import NMAKit


enum MapPin {
    case user
    case destination
}

class Map {
    
    static let mapView = NMAMapView()
    private static var mapCircle : NMAMapCircle!
    private static var userCircle : NMAMapCircle!
    
    static func setPosition(for mapPin: MapPin, with currentCoordinate: Position) {
        mapView.useHighResolutionMap = true
        mapView.zoomLevel = 14.2
        
        let coordinates = NMAGeoCoordinates(latitude: currentCoordinate.latitude ?? 0.0, longitude: currentCoordinate.longitude ?? 0.0)
        mapView.set(geoCenter: coordinates, animation: .linear)
        mapView.copyrightLogoPosition = NMALayoutPosition.bottomCenter
        
        switch mapPin {
        case .user:
            addUserCircle(coordinates)
        default:
            addMapCircle(coordinates)
        }
    }
    
    static private func addMapCircle(_ coordinates: NMAGeoCoordinates) {
        if mapCircle != nil { mapView.remove(mapCircle!) }
        
        mapCircle = NMAMapCircle(coordinates: coordinates, radius: 50)
        mapCircle!.fillColor = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1)
        mapCircle!.lineWidth = 2
        mapCircle!.lineColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        mapView.add(mapCircle!)
    }
    
    static private func addUserCircle(_ coordinates: NMAGeoCoordinates) {
        if userCircle != nil { mapView.remove(userCircle!) }
        
        userCircle = NMAMapCircle(coordinates: coordinates, radius: 50)
        userCircle.fillColor = #colorLiteral(red: 0, green: 0.495313704, blue: 1, alpha: 1)
        userCircle.lineWidth = 2
        userCircle.lineColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        mapView.add(userCircle)
    }
    
    
    
}
