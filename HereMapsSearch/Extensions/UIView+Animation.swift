//
//  UIView+Animation.swift
//  HereMapsSearch
//
//  Created by Garcia, Bruno (B.C.) on 27/08/19.
//  Copyright © 2019 Garcia, Bruno (B.C.). All rights reserved.
//

import Foundation
import UIKit

extension UIView{
    
    func animShow(){
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseIn],
                       animations: {
                        //self.center.y -= self.bounds.height
                        self.frame = CGRect(x: self.frame.origin.x, y: UIScreen.main.bounds.height - self.frame.height , width: self.frame.width, height: self.frame.height)
                        self.layoutIfNeeded()
        }, completion: nil)
        self.isHidden = false
    }
    
    
    func animHide(){
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveLinear],
                       animations: {
                        //self.center.y += self.bounds.height
                        self.frame = CGRect(x: self.frame.origin.x, y: UIScreen.main.bounds.height , width: self.frame.width, height: self.frame.height)
                        self.layoutIfNeeded()
                        
        },  completion: {(_ completed: Bool) -> Void in
            self.isHidden = true
        })
    }
}
