//
//  DetailViewModelTests.swift
//  HereMapsSearchTests
//
//  Created by Garcia, Bruno (B.C.) on 02/09/19.
//  Copyright © 2019 Garcia, Bruno (B.C.). All rights reserved.
//

import XCTest
@testable import HereMapsSearch

class DetailViewModelTests: XCTestCase {

    var locationService: LocationDetailServiceMock?
    var imageService: ImageServiceMock?
    var sut: DetailViewModel?
    
    let locationId = "NT_31Ke13I92N.lMgghc7NEoB"
    let addressLabel = "Avenida Paulista, Bela Vista, São Paulo - SP, 01311-000, Brasil"
    let latitude = -23.56943
    let longitude = -46.64661
    
    
    
    override func setUp() {
        super.setUp()
        locationService = LocationDetailServiceMock()
        imageService = ImageServiceMock()
        sut = DetailViewModel(locationService: locationService!, imageService: imageService!)
    }

    override func tearDown() {
        locationService = nil
        imageService = nil
        sut = nil
        super.tearDown()
    }

    func test_generate_location_data_mock(){
        let sutResponse = MockDataHelper.getGeocoderMock()
        
        guard let responseView = sutResponse.response else {
            XCTFail("No records found on response")
            return
        }
        
        guard let viewR = responseView.view else {
            XCTFail("No records found on response view")
            return
        }
        
        if viewR.count == 0 {
            XCTFail("No records found on response view result")
            return
        }
        
        guard let locationArr = viewR[0].result else {
            XCTFail("No records found on location")
            return
        }
        
        if locationArr.count == 0 {
            XCTFail("No records found on location")
            return
        }
        
        if let location = locationArr[0].location {
            
            if let address = location.address {
                XCTAssertEqual(address.label ?? "", addressLabel, "Expected: \(addressLabel) / Found: \(address.label ?? "") ")
            } else {
                XCTFail("No address found")
            }
            
            if let position = location.displayPosition {
                XCTAssertEqual( position.latitude ?? 0.0 , latitude, "Expected: \(latitude) / Found: \(position.latitude ?? 0.0) ")
                XCTAssertEqual( position.longitude ?? 0.0 , longitude, "Expected: \(longitude) / Found: \(position.longitude ?? 0.0) ")
            } else {
                XCTFail("No position found")
            }
            
        } else {
            XCTFail("No records found on location")
        }
    }
    
    func test_generate_image_data_mock(){
        let sutResponse = MockDataHelper.getImageMock()
        XCTAssertNotNil(sutResponse?.pngData(), "Location Image should not be nil")
    }
    
    func test_fetch_location_when_api_result_is_ok() {
        
        guard let sut = sut else {
            XCTFail("sut not been initialized")
            return
        }
        
        guard let locationService = locationService else {
            XCTFail("location service not been initialized")
            return
        }
        
        let expectation = self.expectation(description: "fetchngData")
        sut.didFinishFetch = { expectation.fulfill() }
        sut.fetchData(locationId)
        locationService.fetchSuccess()
        waitForExpectations(timeout: 5, handler: nil)
        
        if let location = sut.location {
            if let address = location.address {
                XCTAssertEqual(address.label ?? "", addressLabel, "Expected: \(addressLabel) / Found: \(address.label ?? "") ")
            } else {
                XCTFail("No address found")
            }
            
            if let position = location.displayPosition {
                XCTAssertEqual( position.latitude ?? 0.0 , latitude, "Expected: \(latitude) / Found: \(position.latitude ?? 0.0) ")
                XCTAssertEqual( position.longitude ?? 0.0 , longitude, "Expected: \(longitude) / Found: \(position.longitude ?? 0.0) ")
            } else {
                XCTFail("No position found")
            }
            
        } else {
            XCTFail("No location found")
        }
    }
    
    func test_when_jasonfail_on_service() {
        
        guard let sut = sut else {
            XCTFail("sut not been initialized")
            return
        }
        
        guard let locationService = locationService else {
            XCTFail("location service not been initialized")
            return
        }
         
        let expectation = self.expectation(description: "fetchngData")
        sut.didFinishFetch = { expectation.fulfill() }
        sut.showAlertClosure = { expectation.fulfill() }
        sut.fetchData(locationId)
        locationService.fetchFail(error: .invalidJSON)
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNotNil(sut.error, "sut error should be .invalidJson")
        
    }
    
    func test_fetch_image_when_api_result_is_ok() {
        
        guard let sut = sut else {
            XCTFail("sut not been initialized")
            return
        }
        
        guard let imageService = imageService else {
            XCTFail("image service not been initialized")
            return
        }
        
        let expectation = self.expectation(description: "fetchngData")
        sut.didFinishFetchImage = { expectation.fulfill() }
        sut.fetchImage("\(latitude),\(longitude)")
        imageService.fetchSuccess()
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertNotNil(sut.locationImage?.pngData(), "Location Image should not be nil")
    }
    
    func test_when_imagefail_on_service() {
        
        guard let sut = sut else {
            XCTFail("sut not been initialized")
            return
        }
        
        guard let imageService = imageService else {
            XCTFail("image service not been initialized")
            return
        }
        
        let expectation = self.expectation(description: "fetchngData")
        sut.didFinishFetchImage = { expectation.fulfill() }
        sut.showAlertClosure = { expectation.fulfill() }
        
        sut.fetchImage("\(latitude),\(longitude)")
        imageService.fetchFail()
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNil(sut.locationImage, "sut error should be nil")
    }
    
    

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
