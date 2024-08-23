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
        PersonService.shared.fetchCompletePersonsDetails(results: 10) { result in
            switch result {
            case .success(let data):
                print("DEBUG: save remote data to local")
            case .failure(let failure):
                print("DEBUG: Error fetching persons complete details")
            }
        }
    }
    
    func loadMorePersons() {
        PersonService.shared.loadMorePersons {
            print("DEBUG: load more 10 persons")
        }
    }
}
