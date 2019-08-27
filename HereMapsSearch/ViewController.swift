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
   
    var resultSearchIsShown = false
    
    var mapCircle : NMAMapCircle? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        viewSearch.layer.cornerRadius = 10
        viewSearch.layer.shadowPath = UIBezierPath(rect: viewSearch.bounds).cgPath
        viewSearch.layer.shadowRadius = 5
        viewSearch.layer.shadowOffset = .zero
        viewSearch.layer.shadowOpacity = 0.2
        viewSearch.layer.borderWidth = 0.5
        viewSearch.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        
        
        
       
        /*
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        */
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //viewSearchResult.animHide()
    }
   
    /*
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
     */
    
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
        
        
        if resultSearchIsShown {
            UIView.animate(withDuration: 0.5, delay: 0, options: [.curveLinear],
                           animations: {
                            //self.center.y += self.bounds.height
                            self.viewSearch.frame = CGRect(x: self.viewSearch.frame.origin.x, y: self.viewSearch.frame.origin.y , width: self.viewSearch.frame.width, height: self.viewSearch.frame.height - 300)
                            
                            self.viewSearch.layoutIfNeeded()
                            
            },  completion: {(_ completed: Bool) -> Void in
                
                self.resultSearchIsShown = false
            })
        } else {
            UIView.animate(withDuration: 0.5, delay: 0, options: [.curveLinear],
                           animations: {
                            //self.center.y += self.bounds.height
                            self.viewSearch.frame = CGRect(x: self.viewSearch.frame.origin.x, y: self.viewSearch.frame.origin.y , width: self.viewSearch.frame.width, height: self.viewSearch.frame.height + 300)
                            //self.viewSearch.layer.shadowPath = UIBezierPath(rect: self.viewSearch.bounds).cgPath
                            self.viewSearch.layoutIfNeeded()
                            
            },  completion: {(_ completed: Bool) -> Void in

                self.resultSearchIsShown = true
            })
        }
        
        
    }
    
}

