//
//  PersonListViewModel.swift
//  LazyLoadingList
//
//  Created by Gerard on 8/23/24.
//

import Foundation

class PersonListViewModel {
    
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
        
        PersonService.shared.fetchCompletePersonsDetails(results: 30) { [weak self] result in
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
            print("DEBUG: load local persons: Persons \(self.persons?.count ?? 0)")
            completion()
        } else {
            // remote loading
            PersonService.shared.loadMoreCompletePersonsDetails(results: 10) { [weak self] result in
                switch result {
                case .success(let data):
                    UserDefaultsManager.shared.appendPersonsToUserDefaults(newPersons: data)
                    self?.persons = UserDefaultsManager.shared.loadPersonFromUserDefaults()
                    self?.reloadData?()
                    print("DEBUG: load remote persons: Persons \(self?.persons?.count ?? 0)")
                    completion()
                case .failure(_):
                    print("DEBUG: Error fetching more persons complete details")
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
        
        PersonService.shared.fetchCompletePersonsDetails(results: 30) { [weak self] result in
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
