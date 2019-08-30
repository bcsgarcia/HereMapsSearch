//
//  DetailViewController.swift
//  HereMapsSearch
//
//  Created by Garcia, Bruno (B.C.) on 28/08/19.
//  Copyright © 2019 Garcia, Bruno (B.C.). All rights reserved.
//

import UIKit
import NMAKit
import CoreData

class DetailViewController: BaseViewController, CLLocationManagerDelegate {

    @IBOutlet weak var mapContainer: UIView!
    @IBOutlet weak var lblStreet: UILabel!
    @IBOutlet weak var lblDistrict: UILabel!
    @IBOutlet weak var lblState: UILabel!
    @IBOutlet weak var lblPostalCode: UILabel!
    @IBOutlet weak var lblLatitude: UILabel!
    @IBOutlet weak var lblLongitude: UILabel!
    @IBOutlet weak var lblDistance: UILabel!
    @IBOutlet weak var btnFavorite: UIBarButtonItem!
    
    var isFavorite = false
    var locationImage: UIImage? = nil
    var favorite: Favorite? = nil
    var suggestion = Suggestion()
    let viewModel = DetailViewModel()
    
    let locationManager = CLLocationManager()
    var currentCoordinate = Position()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnFavorite.isEnabled = false
        
        Map.mapView.frame = mapContainer.bounds
        Map.mapView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        mapContainer.addSubview(Map.mapView)
        
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        }
        
        setViewModelClosures()
        attemptFecthLocation()
        loadCoreDataFavorite()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        URLCache.shared.removeAllCachedResponses()
    }
    
    func setViewModelClosures() {
        
        viewModel.updateLoadingStatus = {
            if self.viewModel.isLoading {
                self.activityIndicatorStart()
            } else {
                self.activityIndicatorStop()
            }
        }
        
        viewModel.showAlertClosure = {
            if let error = self.viewModel.error {
                var msgError = "Error, please try again"
                switch error {
                case .noResponse, .noData:
                    msgError = "No data found"
                case .noInternetConnection:
                    msgError = "Please verify your internet connection"
                case .messageError(let message):
                    msgError = message
                default:
                    msgError = "Error, please try again"
                }
                self.showAlert(msgError)
            }
        }
        
        viewModel.didFinishFetch = {
            DispatchQueue.main.async {
                
                guard let location = self.viewModel.location else {
                    return
                }
                
                if let address = location.address {
                    self.lblStreet.text = address.street
                    self.lblState.text = address.state
                    self.lblPostalCode.text = address.postalCode
                    self.lblDistrict.text = address.district
                }
                
                if let coordinates = location.displayPosition {
                    self.lblLatitude.text = "\(coordinates.latitude ?? 0.0)"
                    self.lblLongitude.text = "\(coordinates.longitude ?? 0.0)"
                    self.currentCoordinate = coordinates
                }
                
                self.lblDistance.text = "\(self.suggestion.distance ?? 0)"
                
                Map.setPosition(for: .destination, with: self.currentCoordinate)
                
                self.viewModel.fetchImage(self.currentCoordinate.toString())
            }
        }
        
        viewModel.didFinishFetchImage = {
            DispatchQueue.main.async {
                self.btnFavorite.isEnabled = true
            }
        }
    }
    
    func attemptFecthLocation() {
        viewModel.fetchData(suggestion.locationId ?? "")
    }
    
    func loadCoreDataFavorite(){
        
        guard let locationId = suggestion.locationId else {
            return
        }
        
        let fetchRequest: NSFetchRequest<Favorite> = Favorite.fetchRequest()
        let predicate = NSPredicate(format: "locationId = %@", locationId)
        fetchRequest.predicate = predicate
        do {
            let favorites = try context.fetch(fetchRequest)
            if  favorites.count != 0 {
                favorite = favorites[0]
                isFavorite = true
                btnFavorite.title = "Remove Favorite"
            }
        } catch {
            print(error)
        }
    }
    
    @IBAction func addFavoriteClick(_ sender: Any) {
        
        guard let location = viewModel.location else {
            return
        }
        
        isFavorite = !isFavorite
        
        if isFavorite {
            if favorite == nil {
                favorite = Favorite(context: context)
            }
            
            if let _ = favorite {
                favorite?.locationId = location.locationId
                favorite?.image = self.viewModel.locationImage?.pngData()
                favorite?.label = location.address?.label
                favorite?.latitude = location.displayPosition?.latitude ?? 0.0
                favorite?.longitude = location.displayPosition?.longitude ?? 0.0
                btnFavorite.title = "Remove Favorite"
            }
        } else {
            if let _favorite = favorite {
                btnFavorite.title = "Add Favorite"
                context.delete(_favorite)
                favorite = nil
            }
        }
        saveContext()
    }
}
