//
//  UserDefaultsManager.swift
//  LazyLoadingList
//
//  Created by Gerard on 8/24/24.
//

import Foundation

final class UserDefaultsManager {
        
    // MARK: person
    static func savePersonToUserDefaults(person: [Person]) {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(person)
            UserDefaults.standard.set(data, forKey: Constants.Defaults.personsDefaultKey)
        } catch {
            print("Failed to encode person: \(error)")
        }
    }
    
    static func appendPersonsToUserDefaults(newPersons: [Person]) {
        guard var persons = self.loadPersonFromUserDefaults() else { return }
        persons.append(contentsOf: newPersons)
        self.savePersonToUserDefaults(person: persons)
    }
    
    static func loadPersonFromUserDefaults() -> [Person]? {
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
    
    static func removePersons() {
        UserDefaults.standard.removeObject(forKey: Constants.Defaults.personsDefaultKey)
    }
    
    //MARK: seed
    static func savePersonSeed(seed: String) {
        UserDefaults.standard.set(seed, forKey: Constants.Defaults.personsSeedDefaultKey)
    }
    
    static func loadPersonSeed() -> String? {
        guard let retrievedSeed = UserDefaults.standard.string(forKey: Constants.Defaults.personsSeedDefaultKey) else {
            return nil
        }
        return retrievedSeed
    }
    
    static func removePersonSeed() {
        UserDefaults.standard.removeObject(forKey: Constants.Defaults.personsSeedDefaultKey)
    }
}
