//
//  PersonsService.swift
//  LazyLoadingList
//
//  Created by Gerard on 8/23/24.
//

import Foundation
import UIKit

final class PersonService {
        
    private var persons : [Person]?
    private var contactPerson : [Person.ContactPerson]?
    
    //MARK: public methods
    func fetchCompletePersonsDetails(results: Int, completion: @escaping (Result<[Person], APError>) -> Void) {
         let dispatchGroup = DispatchGroup()
         
        dispatchGroup.enter()
        fetchPersons(results: results) { [weak self] result in
            switch result {
            case .success(let data):
                self?.persons = data
            case .failure(_):
                print("DEBUG: Error fetching Persons")
            }
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        fetchContactPerson(results: results) { [weak self] result in
            switch result {
            case .success(let data):
                self?.contactPerson = data
            case .failure(_):
                print("DEBUG: Error fetching Contact Persons")
            }
            dispatchGroup.leave()
        }
         
         dispatchGroup.notify(queue: .main) {
             if let persons = self.combineContactPerson() {
                 completion(.success(persons))
             } else {
                 completion(.failure(.unableToComplete))
             }
         }
    }
    
    func loadMoreCompletePersonsDetails(results: Int, page:Int, completion: @escaping (Result<[Person], APError>) -> Void) {
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        loadMorePersons(results: results, page: page) { [weak self] result in
            switch result {
            case .success(let data):
                self?.persons = data
            case .failure(_):
                print("DEBUG: Error fetching Persons")
            }
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        fetchContactPerson(results: results) { [weak self] result in
            switch result {
            case .success(let data):
                self?.contactPerson = data
            case .failure(_):
                print("DEBUG: Error fetching Contact Persons")
            }
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) {
            // completion
            if let persons = self.combineContactPerson() {
                completion(.success(persons))
            } else {
                completion(.failure(.unableToComplete))
            }
        }
    }

    //MARK: private methods
    private func combineContactPerson() -> [Person]? {
        if let persons = self.persons,
           let contactPerson = self.contactPerson {
            
            var arr : [Person]? = []
            
            for var (index,person) in persons.enumerated() {
                person.contactPerson = contactPerson[index]
                arr?.append(person)
            }
            
            return arr
        } else {
            return nil
        }
    }
    
    private func fetchPersons(results: Int, completion: @escaping (Result<[Person], APError>) -> Void) {
        let urlString = String(format: Constants.API.Person.getNumberOfPersons, results)
        
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, res, error in
            if let _ = error {
                completion(.failure(.unableToComplete))
                return
            }
            
            guard let res = res as? HTTPURLResponse, res.statusCode == 200 else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            
            do {
                let persons = try JSONDecoder().decode(PersonAPIResponse.self, from: data)
                UserDefaultsManager.savePersonSeed(seed: persons.info.seed)
                completion(.success(persons.results))
            } catch {
                completion(.failure(.invalidData))
            }
        }.resume()
    }
    
    private func fetchContactPerson(results:Int, completion: @escaping (Result<[Person.ContactPerson], APError>) -> Void) {
        let urlString = String(format: Constants.API.Person.getRandomContactPersons, results)
        
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, res, error in
            if let _ = error {
                completion(.failure(.unableToComplete))
                return
            }
            
            guard let res = res as? HTTPURLResponse, res.statusCode == 200 else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            
            do {
                let persons = try JSONDecoder().decode(ContactPersonAPIResponse.self, from: data)
                completion(.success(persons.results))
            } catch {
                completion(.failure(.invalidData))
            }
        }.resume()
    }
    
    private func loadMorePersons(results:Int, page:Int, completion: @escaping (Result<[Person], APError>) -> Void) {
        guard let retrievedSeed = UserDefaultsManager.loadPersonSeed() else {
            completion(.failure(.unableToComplete))
            return
        }
                
        let urlString = String(format: Constants.API.Person.getMorePersons, page, results, retrievedSeed)
        
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, res, error in
            if let _ = error {
                completion(.failure(.unableToComplete))
                return
            }
            
            guard let res = res as? HTTPURLResponse, res.statusCode == 200 else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            
            do {
                let persons = try JSONDecoder().decode(PersonAPIResponse.self, from: data)
                completion(.success(persons.results))
            } catch {
                completion(.failure(.invalidData))
            }
        }.resume()
    }
    
}
