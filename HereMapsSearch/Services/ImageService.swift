//
//  ImageService.swift
//  HereMapsSearch
//
//  Created by Bruno Garcia on 29/08/19.
//  Copyright © 2019 Garcia, Bruno (B.C.). All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage

protocol ImageServiceProtocol {
    func fetchImageData(coordinates: String, completion: @escaping (UIImage?) -> ())
}

class ImageService : ImageServiceProtocol {
    
    func fetchImageData(coordinates: String, completion: @escaping (UIImage?) -> ()) {
        
        let baseURLString = Config.sharedInstance.IMAGE_URL
        let relativePath = "?app_id=\(Config.sharedInstance.APP_ID)&app_code=\(Config.sharedInstance.APP_CODE)&c=\(coordinates)&u=1k&h=300&w=420"
        
        Alamofire.request(baseURLString + relativePath).responseImage { response in
            if let image = response.result.value {
                completion(image)
            } else {
                completion(nil)
            }
        }
    }
}
