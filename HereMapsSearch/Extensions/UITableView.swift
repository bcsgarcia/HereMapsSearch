//
//  UITableView.swift
//  HereMapsSearch
//
//  Created by Garcia, Bruno (B.C.) on 30/08/19.
//  Copyright © 2019 Garcia, Bruno (B.C.). All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
    
    func showEmpty(message: String) {
        let rect: CGRect = CGRect(origin: CGPoint(x: 0, y: 0), size: self.bounds.size)
        let messageLabel = UILabel(frame: rect)
        messageLabel.text = message
        messageLabel.textColor = .white
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 15)
        messageLabel.sizeToFit()
        
        self.backgroundView = messageLabel
        self.separatorStyle = .none
    }
    
    func hideEmpty() {
        self.backgroundView = nil
        self.separatorStyle = .none
    }
}
