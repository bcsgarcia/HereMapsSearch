//
//  ViewController.swift
//  HereMapsSearch
//
//  Created by Garcia, Bruno (B.C.) on 27/08/19.
//  Copyright © 2019 Garcia, Bruno (B.C.). All rights reserved.
//

import UIKit
import NMAKit

class ViewController: UIViewController {

    @IBOutlet weak var mapView: NMAMapView!
    @IBOutlet weak var viewSearch: UIView!
    @IBOutlet weak var viewSearchResult: UIView!
    
    var mapCircle : NMAMapCircle? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        viewSearch.layer.cornerRadius = 10
        viewSearch.layer.shadowPath = UIBezierPath(rect: viewSearch.bounds).cgPath
        viewSearch.layer.shadowRadius = 5
        viewSearch.layer.shadowOffset = .zero
        viewSearch.layer.shadowOpacity = 0.5
        
        viewSearchResult.layer.cornerRadius = 10
        viewSearchResult.layer.shadowPath = UIBezierPath(rect: viewSearchResult.bounds).cgPath
        viewSearchResult.layer.shadowRadius = 5
        viewSearchResult.layer.shadowOffset = .zero
        viewSearchResult.layer.shadowOpacity = 0.5
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //viewSearchResult.animHide()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mapView.useHighResolutionMap = true
        mapView.zoomLevel = 13.2
        mapView.set(geoCenter: NMAGeoCoordinates(latitude: 49.258867, longitude: -123.008046),
                    animation: .linear)
        mapView.copyrightLogoPosition = NMALayoutPosition.bottomCenter
        addMapCircle()
        
    }
    
    func addMapCircle() {
        if mapCircle == nil {
            let coordinates: NMAGeoCoordinates =
                NMAGeoCoordinates(latitude: 49.258867, longitude: -123.008046)
            mapCircle = NMAMapCircle(coordinates: coordinates, radius: 50)
            mapView.add(mapCircle!)
        }
    }
    
    @IBAction func showHideClick(_ sender: Any) {
        
        if viewSearchResult.isHidden {
            viewSearchResult.animShow()
        } else {
            viewSearchResult.animHide()
        }
        
    }
    
}

