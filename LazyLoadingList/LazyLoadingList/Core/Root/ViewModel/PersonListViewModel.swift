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

    func fetchPersons() {
        if UserDefaultsManager.shared.loadPersonFromUserDefaults() != nil {
            // reset paging to 1
            UserDefaultsManager.shared.savePersonPage(page: 1)
            
            if let localPersons = UserDefaultsManager.shared.loadPersonFromUserDefaults() {
                self.persons = Array(localPersons.prefix(10))
                self.reloadData?()
            }
            return
        }
        
        service.fetchCompletePersonsDetails(results: 30) { [weak self] result in
            switch result {
            case .success(let data):
                UserDefaultsManager.shared.savePersonToUserDefaults(person: data)
                if let localPerson = UserDefaultsManager.shared.loadPersonFromUserDefaults() {
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
           let localPersons = UserDefaultsManager.shared.loadPersonFromUserDefaults(),
           persons.count != localPersons.count {
            
            let nextPage = UserDefaultsManager.shared.loadPersonPage()+1

            let results = 10*nextPage
            self.persons = Array(localPersons.prefix(results))
            self.reloadData?()
            UserDefaultsManager.shared.savePersonPage(page: nextPage)
            completion()
        } else {
            // remote loading
            service.loadMoreCompletePersonsDetails(results: 10) { [weak self] result in
                switch result {
                case .success(let data):
                    UserDefaultsManager.shared.appendPersonsToUserDefaults(newPersons: data)
                    self?.persons = UserDefaultsManager.shared.loadPersonFromUserDefaults()
                    self?.reloadData?()
                    completion()
                case .failure(_):
                    print("DEBUG: Error fetching more persons complete details")
                    completion()
                }
            }
        }
    }
    
    func refreshPersons() {
        if UserDefaultsManager.shared.loadPersonFromUserDefaults() == nil {
            return
        }
        
        UserDefaultsManager.shared.removePersons()
        UserDefaultsManager.shared.removePersonPage()
        UserDefaultsManager.shared.removePersonSeed()
        
        service.fetchCompletePersonsDetails(results: 30) { [weak self] result in
            switch result {
            case .success(let data):
                UserDefaultsManager.shared.savePersonToUserDefaults(person: data)
                if let localPerson = UserDefaultsManager.shared.loadPersonFromUserDefaults() {
                    self?.persons = Array(localPerson.prefix(10))
                    self?.reloadData?()
                }
            case .failure(_):
                print("DEBUG: Error fetching persons complete details")
            }
        }
    }
}
