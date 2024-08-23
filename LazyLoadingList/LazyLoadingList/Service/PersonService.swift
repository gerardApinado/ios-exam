//
//  PersonsService.swift
//  LazyLoadingList
//
//  Created by Gerard on 8/23/24.
//

import Foundation

class PersonService {
    
    static let shared = PersonService()
    
    private init() {
        
    }
    
    func fetchPersons(completion: @escaping () -> Void) {
        
        completion()
    }
    
    func loadMorePersons(completion: @escaping () -> Void) {
        
        completion()
    }
    
}
