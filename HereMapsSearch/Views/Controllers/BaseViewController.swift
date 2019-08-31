//
//  BaseViewController.swift
//  HereMapsSearch
//
//  Created by Garcia, Bruno (B.C.) on 29/08/19.
//  Copyright © 2019 Garcia, Bruno (B.C.). All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    // MARK: - Properties
    var indicator = UIActivityIndicatorView()
    var checkInternetTimer: Timer!
    let checkInternetTimeInterval : TimeInterval = 3
    
    // MARK: - Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator()
    }
    
    func setupMap(with mapContainer: UIView) {
        Map.mapView.frame = mapContainer.bounds
        Map.mapView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        mapContainer.addSubview(Map.mapView)
        mapContainer.layer.borderWidth = 1
        mapContainer.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
    
    func activityIndicatorStart() {
        indicator.isHidden = false
        indicator.startAnimating()
    }
    
    func activityIndicatorStop() {
        indicator.stopAnimating()
    }
    
    func activityIndicator() {
        indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        indicator.style = UIActivityIndicatorView.Style.gray
        indicator.center = self.view.center
        self.view.addSubview(indicator)
    }
    
    func showAlert(_ message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Internet Connection
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
        }
    }
}
