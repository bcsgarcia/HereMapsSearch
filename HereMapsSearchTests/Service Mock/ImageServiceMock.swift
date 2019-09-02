//
//  ImageServiceMock.swift
//  HereMapsSearchTests
//
//  Created by Garcia, Bruno (B.C.) on 02/09/19.
//  Copyright © 2019 Garcia, Bruno (B.C.). All rights reserved.
//

import Foundation
import UIKit
@testable import HereMapsSearch

class ImageServiceMock: ImageServiceProtocol {
    
    var completeClosureFetchImage: ((UIImage?) -> ())!
    
    func fetchImageData(coordinates: String, completion: @escaping (UIImage?) -> ()) {
        completeClosureFetchImage = completion
    }
    
    // Mocking Success
    func fetchSuccess() {
        completeClosureFetchImage(MockDataHelper.getImageMock())
    }
    
    //Mocking Error
    func fetchFail() {
        completeClosureFetchImage(nil)
    }
    
}
