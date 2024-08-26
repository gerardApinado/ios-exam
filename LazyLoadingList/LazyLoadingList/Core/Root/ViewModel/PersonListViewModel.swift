//
//  PersonListViewModel.swift
//  LazyLoadingList
//
//  Created by Gerard on 8/23/24.
//

import Foundation

class PersonListViewModel {
    
    private let service = PersonService()
    
    var persons: [Person]?
    
    var reloadData: (() -> Void)?
    var page: Int = 1

    func fetchPersons() {
        if UserDefaultsManager.loadPersonFromUserDefaults() != nil {
            // reset paging to 1
            page = 1
            if let localPersons = UserDefaultsManager.loadPersonFromUserDefaults() {
                self.persons = Array(localPersons.prefix(10))
                self.reloadData?()
            }
            return
        }
        
        service.fetchCompletePersonsDetails(results: 30) { [weak self] result in
            switch result {
            case .success(let data):
                UserDefaultsManager.savePersonToUserDefaults(person: data)
                if let localPerson = UserDefaultsManager.loadPersonFromUserDefaults() {
                    self?.persons = Array(localPerson.prefix(10))
                    self?.reloadData?()
                }
            case .failure(_):
                print("DEBUG: Error fetching persons complete details")
            }
        }
    }
    
    func loadMorePersons(completion: @escaping () -> Void) {
        // local loading
        if let persons = self.persons,
           let localPersons = UserDefaultsManager.loadPersonFromUserDefaults(),
           persons.count != localPersons.count {
            
            let nextPage = page+1

            let results = 10*nextPage
            self.persons = Array(localPersons.prefix(results))
            self.reloadData?()

            page = nextPage
            completion()
        } else {
            // remote loading
            let nextPage = page+1
            
            service.loadMoreCompletePersonsDetails(results: 10, page: nextPage) { [weak self] result in
                switch result {
                case .success(let data):
                    UserDefaultsManager.appendPersonsToUserDefaults(newPersons: data)
                    self?.persons = UserDefaultsManager.loadPersonFromUserDefaults()
                    self?.reloadData?()
                    self?.page = nextPage
                    completion()
                case .failure(_):
                    print("DEBUG: Error fetching more persons complete details")
                    completion()
                }
            }
        }
    }
    
    func refreshPersons() {
        if UserDefaultsManager.loadPersonFromUserDefaults() == nil {
            return
        }
        
        UserDefaultsManager.removePersons()
        UserDefaultsManager.removePersonSeed()
        
        service.fetchCompletePersonsDetails(results: 30) { [weak self] result in
            switch result {
            case .success(let data):
                UserDefaultsManager.savePersonToUserDefaults(person: data)
                if let localPerson = UserDefaultsManager.loadPersonFromUserDefaults() {
                    self?.page = 1
                    self?.persons = Array(localPerson.prefix(10))
                    self?.reloadData?()
                }
            case .failure(_):
                print("DEBUG: Error fetching persons complete details")
            }
        }
    }
}
