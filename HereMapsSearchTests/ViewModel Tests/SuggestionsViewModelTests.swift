//
//  SuggestionsViewModelTests.swift
//  HereMapsSearchTests
//
//  Created by Garcia, Bruno (B.C.) on 01/09/19.
//  Copyright © 2019 Garcia, Bruno (B.C.). All rights reserved.
//

import XCTest
@testable import HereMapsSearch

class SuggestionsViewModelTests: XCTestCase {
    
    var service: SuggestionsServiceMock?
    var sut: SuggestionsViewModel?
    
    let querySearch = "Avenida Paulista"
    let labelResult = "Brasil, 01311-000, São Paulo, Avenida Paulista"
    let prox = "-23.649162,-46.588526,5000"
    let suggestionsCount = 5

    override func setUp() {
        super.setUp()
        service = SuggestionsServiceMock()
        sut = SuggestionsViewModel(suggestionsService: service!) 
    }

    override func tearDown() {
        service = nil
        sut = nil
        super.tearDown()
    }
    
    func test_generate_data_mock(){
        let sutResponse = MockDataHelper.getAutocompleteMock()
        if let suggestions = sutResponse.suggestions {
            XCTAssertEqual(suggestions.count , suggestionsCount, "Expected: \(suggestionsCount) / Found: \(suggestions.count)")
        } else {
            XCTFail("No records found")
        }
    }
    
    func test_fetch_suggestions_when_api_result_is_ok() {
        guard let sut = sut else {
            XCTFail("sut not been initialized")
            return
        }
        
        guard let service = service else {
            XCTFail("service not been initialized")
            return
        }
        
        let expectation = self.expectation(description: "fetchngData")
        sut.didFinishFetch = { expectation.fulfill() }
        sut.fetchData(query: querySearch, prox: prox)
        service.fetchSuccess()
        waitForExpectations(timeout: 5, handler: nil)
        
        if sut.suggestionCellViewModels.count > 0 {
            
            XCTAssertEqual(sut.suggestionCellViewModels.count, suggestionsCount, "Esperado: \(suggestionsCount) / Encontrado \(sut.suggestionCellViewModels.count)")
            
            XCTAssertEqual(sut.suggestionCellViewModels[0].suggestion.label ?? "", labelResult, "Expected: \(labelResult) / Found \(sut.suggestionCellViewModels[0].suggestion.label ?? "")" )
            
        } else {
            XCTFail("suggestionCellViewModels should have been set")
        }
    }
    
    func test_when_jasonfail_on_service(){
        
        guard let sut = sut else {
            XCTFail("sut not been initialized")
            return
        }
        
        guard let service = service else {
            XCTFail("service not been initialized")
            return
        }
        
        let expectation = self.expectation(description: "fetchngData")
        sut.didFinishFetch = { expectation.fulfill() }
        sut.showAlertClosure = { expectation.fulfill() }
        
        sut.fetchData(query: "", prox: prox)
        service.fetchFail(error: .invalidJSON)
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNotNil(sut.error, "sut error deve ser .invalidJson")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
