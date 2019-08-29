//
//  ViewController.swift
//  HereMapsSearch
//
//  Created by Garcia, Bruno (B.C.) on 27/08/19.
//  Copyright © 2019 Garcia, Bruno (B.C.). All rights reserved.
//

import UIKit
import NMAKit

class MainViewController: BaseViewController, CLLocationManagerDelegate {

    // MARK: - IBOutlet
    @IBOutlet weak var mapView: NMAMapView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: - Properties
    let SECOND = 1000
    let MINUTE = 60 * 1000
    let HOUR = 60 * 60 * 1000
    private var lastPositionUpdate : Int64 = 0;
    
    var viewModel = SuggestionsViewModel()
    var cellViewModels = [SuggestionCellViewModel]()
    
    let cellId = "locationCell"
    let identifier = "segueDetail"
    
    let locationManager = CLLocationManager()
    var resultSearchIsShown = false
    var currentCoordinate = Position()
    var mapCircle : NMAMapCircle? = nil
    
    
    // MARK: - Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        setUpSearchBar()
        setViewModelClosures()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setMapPosition()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        currentCoordinate.latitude = locValue.latitude
        currentCoordinate.longitude = locValue.longitude
    
        setMapPosition()
        locationManager.stopUpdatingLocation()
        
        /*
        let currTime = Int64(NSDate().timeIntervalSince1970 * 1000)
        if Int64(currTime - lastPositionUpdate) > MINUTE/2 {
            //URLCache.shared.removeAllCachedResponses()
            setMapPosition()
        }
         */
    }
    
    private func setUpSearchBar() {
        searchBar.delegate = self
    }
  
    func setMapPosition() {
        mapView.useHighResolutionMap = true
        mapView.zoomLevel = 13.2
        
        let coordinates = NMAGeoCoordinates(latitude: currentCoordinate.latitude ?? 0.0, longitude: currentCoordinate.longitude ?? 0.0)
        mapView.set(geoCenter: coordinates, animation: .linear)
        mapView.copyrightLogoPosition = NMALayoutPosition.bottomCenter
        addMapCircle(coordinates)
    }
  
    func addMapCircle(_ coordinates: NMAGeoCoordinates) {
        if mapCircle != nil {
            mapView.remove(mapCircle!)
        }

        mapCircle = NMAMapCircle(coordinates: coordinates, radius: 90)
        mapCircle!.fillColor = #colorLiteral(red: 0, green: 0.495313704, blue: 1, alpha: 1)
        mapCircle!.lineWidth = 2
        mapCircle!.lineColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        mapView.add(mapCircle!)
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
                switch error {
                case .noResponse, .noData:
                    self.showAlert("Problem with response, please check your internet connection")
                case .noInternetConnection:
                    self.initInternetConnectionCheck()
                    self.showAlert("No network connection available")
                default:
                    print(error)
                }
            }
        }
        
        viewModel.didFinishFetch = {
            self.cellViewModels = self.viewModel.suggestionCellViewModels
            
            self.cellViewModels.sort(by: { $0.suggestion.distance ?? 0 < $1.suggestion.distance ?? 0 })
            
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Fetch Data Function
    func attemptFetchData(query: String) {
        viewModel.fetchData(query: query, prox: currentCoordinate.getProxString())
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == identifier {
            let viewDestiny = segue.destination as! DetailViewController
            if let indexPath = sender as? IndexPath {
                viewDestiny.suggestion = cellViewModels[indexPath.row].suggestion
            }
        }
    }
    
    
    
    
    
}

// MARK: - SearchBar Delegate
extension MainViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let text = searchBar.text {
            attemptFetchData(query: text)
        } else {
            cellViewModels = [SuggestionCellViewModel]()
        }
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        hideKeyboard()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        hideKeyboard()
    }
    
    func hideKeyboard(){
        searchBar.resignFirstResponder()
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
}

// MARK: - UITableView: DataSource & Delegate
extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if cellViewModels.count == 0 {
            tableView.backgroundView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        }
        return cellViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? LocationTableViewCell else {
            return UITableViewCell()
        }
        
        let cellViewModel = cellViewModels[indexPath.row]
        cell.txtLabel.text = cellViewModel.suggestion.label
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        hideKeyboard()
        performSegue(withIdentifier: identifier, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    // search bar in section header
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
}

