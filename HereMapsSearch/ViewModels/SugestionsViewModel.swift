//
//  LocationListViewModel.swift
//  HereMapsSearch
//
//  Created by Bruno Garcia on 27/08/19.
//  Copyright © 2019 Garcia, Bruno (B.C.). All rights reserved.
//

import Foundation

class SuggestionsViewModel: BaseViewModel {
    
    private var suggestionsResponse: SuggestionsResponse? {
        didSet {
            guard let rs = suggestionsResponse else { return }
            self.setupProperties(with: rs.suggestions ?? [])
            self.didFinishFetch?()
        }
    }
    
    var suggestionCellViewModels = [SuggestionCellViewModel]()
    let suggestionsService: SuggestionsServiceProtocol
    
    //Dependency Injection
    init( suggestionsService: SuggestionsServiceProtocol = SuggestionsService() ) {
        self.suggestionsService = suggestionsService
    }
    
    func fetchData(query: String, prox: String) {
        isLoading = true
        
        if !CheckInternet.Connection() {
            isLoading = false
            error = .noInternetConnection
            return
        }
        
        suggestionsService.fetchSuggestions(query: query, prox: prox) { (suggestionsResponse, err) in
            if let err = err {
                self.isLoading = false
                self.error = err
                return
            }
            guard let suggestionsResponse = suggestionsResponse else {
                self.isLoading = false
                return
            }
            self.error = nil
            self.isLoading = false
            self.suggestionsResponse = suggestionsResponse
        }
    }
    
    private func setupProperties(with suggestions: [Suggestion]) {
        self.suggestionCellViewModels = [SuggestionCellViewModel]()
        self.suggestionCellViewModels = self.suggestionCellViewModels + suggestions.map({return SuggestionCellViewModel(suggestion: $0)})
    }
    
}
