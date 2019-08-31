//
//  ViewController.swift
//  HereMapsSearch
//
//  Created by Garcia, Bruno (B.C.) on 27/08/19.
//  Copyright © 2019 Garcia, Bruno (B.C.). All rights reserved.
//

import UIKit
import NMAKit

class MainViewController: BaseViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var mapContainer: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var viewMenu: UIView!
    @IBOutlet weak var scSort: UISegmentedControl!
    
    // MARK: - Properties
    let MINUTE = 60 * 1000
    private var lastPositionUpdate : Int64 = 0;
    
    var viewModel = SuggestionsViewModel()
    var cellViewModels = [SuggestionCellViewModel]()
    
    let cellId = "locationCell"
    let detailIdentifier = "segueDetail"
    let favoriteIdentifier = "segueFavorite"
    
    let locationManager = CLLocationManager()
    var sortMenuIsShow = false
    var sortByDistance = true
    var currentCoordinate = Position()
    var gesture = UITapGestureRecognizer()
    
    
    // MARK: - Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMap(with: mapContainer)
        setupLocationManager()
        setupSearchBar()
        setupViewModelClosures()
        
        gesture = UITapGestureRecognizer(target: self, action: #selector(mapTap))
    }
    
    @objc func mapTap(_ sender:UITapGestureRecognizer){
        self.sortMenuIsShow = false
        self.tableView.isHidden = true
        self.hideShowSortMenu()
        hideKeyboard()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupMap(with: mapContainer)
        Map.setPosition(for: .user, with: currentCoordinate)
        locationManager.startUpdatingLocation()
        Map.mapView.addGestureRecognizer(gesture)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        self.sortMenuIsShow = false
        self.hideShowSortMenu()
    }
    
    private func setupViewModelClosures() {
        viewModel.updateLoadingStatus = {
            let _ = self.viewModel.isLoading ? self.activityIndicatorStart() : self.activityIndicatorStop()
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
            self.sortList()
            self.tableView.reloadData()
            self.tableView.isHidden = self.cellViewModels.count == 0
        }
    }
    
    // MARK: - Fetch Data Function
    private func attemptFetchData(query: String) {
        viewModel.fetchData(query: query, prox: currentCoordinate.getProxString())
    }
    
    // MARK: - Sort Menu
    private func sortList() {
        let _ = self.sortByDistance ?
            self.cellViewModels.sort(by: { $0.suggestion.distance ?? 0 < $1.suggestion.distance ?? 0 }) :
            self.cellViewModels.sort(by: { $0.suggestion.label ?? "" < $1.suggestion.label ?? "" })
    }
    
    func hideShowSortMenu(){
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveLinear], animations: {
            self.viewMenu.frame = !self.sortMenuIsShow ?
                CGRect(x: 0, y: 0 - self.viewMenu.frame.height, width: self.viewMenu.frame.width, height: self.viewMenu.frame.height) :
                CGRect(x: 0, y: 0, width: self.viewMenu.frame.width, height: self.viewMenu.frame.height)
        },  completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        Map.mapView.removeGestureRecognizer(gesture)
        
        if segue.identifier == detailIdentifier {
            let viewDestiny = segue.destination as! DetailViewController
            locationManager.stopUpdatingLocation()
            if let indexPath = sender as? IndexPath {
                tableView.deselectRow(at: indexPath, animated: false)
                viewDestiny.suggestion = cellViewModels[indexPath.row].suggestion
            }
        } else if segue.identifier == favoriteIdentifier {
            locationManager.stopUpdatingLocation()
        }
    }
    
    // MARK: - IBActions
    @IBAction func showFavorites(_ sender: Any) {
        performSegue(withIdentifier: favoriteIdentifier, sender: nil)
    }
    
    @IBAction func sortMenuClick(_ sender: Any) {
        self.sortMenuIsShow = !self.sortMenuIsShow
       self.hideShowSortMenu()
    }
    
    @IBAction func sortChange(_ sender: UISegmentedControl) {
        sortByDistance = sender.selectedSegmentIndex == 0
        if let text = searchBar.text {
            attemptFetchData(query: text)
        } else {
            cellViewModels = [SuggestionCellViewModel]()
            tableView.reloadData()
        }
    }
}

extension MainViewController: CLLocationManagerDelegate {
    
    func setupLocationManager(){
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        
        currentCoordinate.setCoordinates(with: locValue)
        
        let currTime = Int64(NSDate().timeIntervalSince1970 * 1000)
        if Int64(currTime - lastPositionUpdate) > MINUTE/2 {
            Map.setPosition(for: .user, with: currentCoordinate)
            lastPositionUpdate = currTime
        }
    }
}

// MARK: - SearchBar Delegate
extension MainViewController: UISearchBarDelegate {
    
    private func setupSearchBar() {
        searchBar.delegate = self
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let text = searchBar.text {
            attemptFetchData(query: text)
        } else {
            cellViewModels = [SuggestionCellViewModel]()
            tableView.reloadData()
        }
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
        var cell : UITableViewCell!
        cell = tableView.dequeueReusableCell(withIdentifier: cellId)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: cellId)
        }
        
        cell.textLabel?.text = cellViewModels[indexPath.row].suggestion.label
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        hideKeyboard()
        performSegue(withIdentifier: detailIdentifier, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    // search bar in section header
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
}

