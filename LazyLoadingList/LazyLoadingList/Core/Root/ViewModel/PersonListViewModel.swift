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
        PersonService.shared.fetchCompletePersonsDetails(results: 30) { [weak self] result in
            switch result {
            case .success(let data):
                self?.savePersonToUserDefaults(person: data)
                self?.persons = self?.loadPersonFromUserDefaults()
                self?.reloadData?()
            case .failure(let failure):
                print("DEBUG: Error fetching persons complete details")
            }
        }
    }
    
    func loadMorePersons() {
//        PersonService.shared.loadMorePersons {
//            print("DEBUG: load more 10 persons")
//        }
    }
    
    func refreshPersons() {
        if UserDefaults.standard.data(forKey: Constants.Defaults.personsDefaultKey) == nil {
            return
        }
        UserDefaults.standard.removeObject(forKey: Constants.Defaults.personsDefaultKey)
        
        PersonService.shared.fetchCompletePersonsDetails(results: 30) { [weak self] result in
            switch result {
            case .success(let data):
                self?.savePersonToUserDefaults(person: data)
                self?.persons = self?.loadPersonFromUserDefaults()
                self?.reloadData?()
            case .failure(let failure):
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
