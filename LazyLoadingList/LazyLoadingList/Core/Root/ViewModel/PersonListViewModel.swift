//
//  PersonListViewModel.swift
//  LazyLoadingList
//
//  Created by Gerard on 8/23/24.
//

import Foundation

class PersonListViewModel {
    
    var persons: [Person]?

    func fetchPersons() {
        PersonService.shared.fetchPersons(results: 1) { res in
            print("DEBUG: Fetch 30 persons")
        }
    }
    
    func loadMorePersons() {
        PersonService.shared.loadMorePersons {
            print("DEBUG: load more 10 persons")
        }
    }
}
