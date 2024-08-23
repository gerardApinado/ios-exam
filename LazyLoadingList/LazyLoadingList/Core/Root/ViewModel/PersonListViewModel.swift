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
        if UserDefaults.standard.data(forKey: Constants.Defaults.personsDefaultKey) != nil {
            // reset paging to 1
            UserDefaults.standard.set(1, forKey: Constants.Defaults.personsPageDefaultKey)
            
            if let localPersons = self.loadPersonFromUserDefaults(){
                self.persons = Array(localPersons.prefix(10))
                self.reloadData?()
            }
            return
        }
        
        PersonService.shared.fetchCompletePersonsDetails(results: 30) { [weak self] result in
            switch result {
            case .success(let data):
                self?.savePersonToUserDefaults(person: data)
                if let localPerson = self?.loadPersonFromUserDefaults(){
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
           let localPersons = self.loadPersonFromUserDefaults(),
           persons.count != localPersons.count {
            let nextPage = UserDefaults.standard.integer(forKey: Constants.Defaults.personsPageDefaultKey)+1
            if let localPerson = self.loadPersonFromUserDefaults(){
                let results = 10*nextPage
                self.persons = Array(localPerson.prefix(results))
                self.reloadData?()
                print("DEBUG: load local persons: Persons \(self.persons?.count ?? 0)")
                UserDefaults.standard.set(nextPage, forKey: Constants.Defaults.personsPageDefaultKey)
                completion()
            }
        } else {
            // remote loading
            PersonService.shared.loadMoreCompletePersonsDetails(results: 10) { [weak self] result in
                switch result {
                case .success(let data):
                    self?.appendPersonsToUserDefaults(newPersons: data)
                    self?.persons = self?.loadPersonFromUserDefaults()
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
        if UserDefaults.standard.data(forKey: Constants.Defaults.personsDefaultKey) == nil {
            return
        }
        UserDefaults.standard.removeObject(forKey: Constants.Defaults.personsDefaultKey)
        UserDefaults.standard.removeObject(forKey: Constants.Defaults.personsSeedDefaultKey)
        UserDefaults.standard.removeObject(forKey: Constants.Defaults.personsPageDefaultKey)
        
        PersonService.shared.fetchCompletePersonsDetails(results: 30) { [weak self] result in
            switch result {
            case .success(let data):
                self?.savePersonToUserDefaults(person: data)
                if let localPerson = self?.loadPersonFromUserDefaults(){
                    self?.persons = Array(localPerson.prefix(10))
                    self?.reloadData?()
                }
            case .failure(_):
                print("DEBUG: Error fetching persons complete details")
            }
        }
    }
    
    private func savePersonToUserDefaults(person: [Person]) {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(person)
            UserDefaults.standard.set(data, forKey: Constants.Defaults.personsDefaultKey)
        } catch {
            print("Failed to encode person: \(error)")
        }
    }
    
    private func appendPersonsToUserDefaults(newPersons: [Person]) {
        guard var persons = self.loadPersonFromUserDefaults() else { return }
        persons.append(contentsOf: newPersons)
        self.savePersonToUserDefaults(person: persons)
    }
    
    private func loadPersonFromUserDefaults() -> [Person]? {
        if let data = UserDefaults.standard.data(forKey: Constants.Defaults.personsDefaultKey) {
            let decoder = JSONDecoder()
            do {
                let person = try decoder.decode([Person].self, from: data)
                return person
            } catch {
                print("Failed to decode person: \(error)")
            }
        }
        return nil
    }
}
