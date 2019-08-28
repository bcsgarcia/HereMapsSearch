//
//  DetailViewController.swift
//  HereMapsSearch
//
//  Created by Garcia, Bruno (B.C.) on 28/08/19.
//  Copyright © 2019 Garcia, Bruno (B.C.). All rights reserved.
//

import UIKit
import NMAKit

class DetailViewController: UIViewController {

    @IBOutlet weak var mapView: NMAMapView!
    
    
    var suggestion = Suggestion()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func backClick(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
