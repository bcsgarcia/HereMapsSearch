//
//  ViewController.swift
//  HereMapsSearch
//
//  Created by Garcia, Bruno (B.C.) on 27/08/19.
//  Copyright © 2019 Garcia, Bruno (B.C.). All rights reserved.
//

import UIKit
import NMAKit

class MainViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: NMAMapView!
    //@IBOutlet weak var viewSearch: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    let SECOND = 1000
    let MINUTE = 60 * 1000
    let HOUR = 60 * 60 * 1000
    private var lastPositionUpdate : Int64 = 0;
    
    var viewModel = SuggestionsViewModel()
    var cellViewModels = [SuggestionCellViewModel]()
    var indicator = UIActivityIndicatorView()
    var checkInternetTimer: Timer!
    let checkInternetTimeInterval : TimeInterval = 3
    
    let cellId = "locationCell"
    let identifier = "segueDetail"
    
    let locationManager = CLLocationManager()
   
    var resultSearchIsShown = false
    var latitude = 0.0
    var longitude = 0.0
    var currentCoordinate = ""
    
    var mapCircle : NMAMapCircle? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        setUpSearchBar()
        activityIndicator()
        //attemptFetchData()
        alterLayout()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        latitude = locValue.latitude
        longitude = locValue.longitude
        currentCoordinate = "\(locValue.latitude),\(locValue.longitude),500"
        
        let currTime = Int64(NSDate().timeIntervalSince1970 * 1000)
        if Int64(currTime - lastPositionUpdate) > MINUTE {
            setMapPosition()
            addMapCircle()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //viewSearchResult.animHide()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setMapPosition()
        addMapCircle()
        
    }
    
    func alterLayout() {
        //tableView.tableHeaderView = UIView()
        //tableView.estimatedSectionHeaderHeight = 50
    }
   
    private func setUpSearchBar() {
        searchBar.delegate = self
        //searchBar.barTintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        //searchBar.layer.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        //searchBar.barStyle = UIBarStyle.blackTranslucent

    }
  
    
  
    
    func setMapPosition() {
        mapView.useHighResolutionMap = true
        mapView.zoomLevel = 13.2
        mapView.set(geoCenter: NMAGeoCoordinates(latitude: latitude, longitude: longitude), animation: .linear)
        mapView.copyrightLogoPosition = NMALayoutPosition.bottomCenter
        
        let marker = NMAMapMarker(geoCoordinates: NMAGeoCoordinates(latitude: latitude, longitude: longitude))
        mapView.add(marker)
        
    }
  
    func addMapCircle() {
        if mapCircle == nil {
            let coordinates: NMAGeoCoordinates = NMAGeoCoordinates(latitude: latitude, longitude: longitude)
            mapCircle = NMAMapCircle(coordinates: coordinates, radius: 10)
            mapView.add(mapCircle!)
        }
    }
    
    private func activityIndicatorStart() {
        indicator.isHidden = false
        indicator.startAnimating()
    }
    
    private func activityIndicatorStop() {
        indicator.stopAnimating()
    }
    
    func initInternetConnectionCheck(){
        if checkInternetTimer == nil {
            activityIndicatorStart()
            checkInternetTimer = Timer.scheduledTimer(timeInterval: checkInternetTimeInterval, target: self, selector: #selector(checkInernet), userInfo: nil, repeats: true)
        }
    }
    
    @objc func checkInernet(){
        if CheckInternet.Connection() {
            checkInternetTimer.invalidate()
            checkInternetTimer = nil
            activityIndicatorStop()
            //attemptFetchData()
        }
    }
    
    func activityIndicator() {
        indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        indicator.style = UIActivityIndicatorView.Style.gray
        indicator.center = self.view.center
        
        //indicator.hidesWhenStopped = true
        self.view.addSubview(indicator)
    }
    
    func showAlert(_ message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func attemptFetchData(query: String) {
        self.activityIndicatorStart()
        
        viewModel.updateLoadingStatus = { let _ = self.viewModel.isLoading ? self.activityIndicatorStart() : self.activityIndicatorStop() }
        
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
        
        viewModel.fetchData(query: query, prox: currentCoordinate)
    }
    
    
}

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
        //cell.movieCellViewModel = cellViewModel
        cell.txtLabel.text = cellViewModel.suggestion.label
        return cell
    }
    
    //func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    //    return 130
    //}
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        hideKeyboard()
        performSegue(withIdentifier: identifier, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //if indexPath.row == viewModel.movieCellViewModels.count-1 {
        //    self.attemptFetchData()
        //}
    }
    
    // This two functions can be used if you want to show the search bar in the section header
    //func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    //    return searchBar
    //}
    
    // search bar in section header
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
 
    
    
    
    
    
    
}

