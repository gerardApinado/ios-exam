//
//  PersonsService.swift
//  LazyLoadingList
//
//  Created by Gerard on 8/23/24.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

final class PersonService {
    
    static let shared = PersonService()
    
    private var persons : [Person]?
    private var contactPerson : [Person.ContactPerson]?
    
    private var personsRx : BehaviorRelay<[Person]> = BehaviorRelay(value: [])
    private var contactPersonRx : BehaviorRelay<[Person.ContactPerson]> = BehaviorRelay(value: [])
    
    private var disposeBag = DisposeBag()
    
    private init() {
        
    }
    
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
             // completion
             if let persons = self.combineContactPerson() {
                 completion(.success(persons))
             } else {
                 completion(.failure(.unableToComplete))
             }
         }
    }
    
    func fetchCompletePersonsDetailsRx(results: Int) -> Observable<[Person]> {
        return Observable.create { observer in
            let dispatchGroup = DispatchGroup()
            
           dispatchGroup.enter()
            self.fetchPersonsRx(results: results)
               .observe(on: MainScheduler.instance)
//               .bind(to: self.personsRx)
               .subscribe(
                onNext: { persons in
                    self.personsRx.accept(persons)
                },
                onError: { error in
                    dispatchGroup.leave()
                },
                onCompleted: {
                    dispatchGroup.leave()
                }
               )
               .disposed(by: self.disposeBag)
           
           dispatchGroup.enter()
            self.fetchContactPersonRx(results: results)
               .observe(on: MainScheduler.instance)
//               .bind(to: self.contactPersonRx)
               .subscribe(
                onNext: { contactPerson in
                    self.contactPersonRx.accept(contactPerson)
                },
                onError: { error in
                    dispatchGroup.leave()
                },
                onCompleted: {
                    dispatchGroup.leave()
                }
               )
               .disposed(by: self.disposeBag)
            
            dispatchGroup.notify(queue: .main) {
                // combine
//                Observable.combineLatest(self.personsRx, self.contactPersonRx) { persons, contactPersons in
//                    let count = min(persons.count, contactPersons.count)
//                    return (0..<count).map { index in
//                        var updatedPerson = persons[index]
//                        updatedPerson.contactPerson = contactPersons[index]
//                        return updatedPerson
//                    }
//                }
//                .bind(to: self.personsRx)
//                .disposed(by: self.disposeBag)
                
                observer.onNext(self.personsRx.value)
                observer.onCompleted()
            }
            
            return Disposables.create()
        }
    }
    
    func loadMoreCompletePersonsDetails(results: Int, completion: @escaping (Result<[Person], APError>) -> Void) {
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        loadMorePersons(results: results) { [weak self] result in
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
    
    private func combineContactPersonRx() -> [Person]? {
        var arr : [Person]? = []
        
//        for var (index,person) in personsRx.enumerated() {
//            person.contactPerson = contactPerson[index]
//            arr?.append(person)
//        }
        
        return arr
    }
    
    func fetchPersonsRx(results: Int) -> Observable<[Person]> {
        let urlString = String(format: Constants.API.Person.getNumberOfPersons, results)
        
        return Observable.create { observer in
            guard let url = URL(string: urlString) else {
                observer.onError(APError.invalidURL)
                return Disposables.create()
            }
            
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    observer.onError(APError.unableToComplete)
                    return
                }
                
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    observer.onError(APError.invalidResponse)
                    return
                }
                
                guard let data = data else {
                    observer.onError(APError.invalidData)
                    return
                }
                
                do {
                    // fetch 30 Pesons
                    let persons = try JSONDecoder().decode(PersonAPIResponse.self, from: data)
                                    
                    UserDefaultsManager.shared.savePersonSeed(seed: persons.info.seed)
                    UserDefaultsManager.shared.savePersonPage(page: persons.info.page)
                    
                    observer.onNext(persons.results)
                    observer.onCompleted()
                } catch {
                    observer.onError(APError.unableToComplete)
                }
            }
            
            task.resume()
            return Disposables.create {
                task.cancel()
            }
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
                // fetch 30 Pesons
                let persons = try JSONDecoder().decode(PersonAPIResponse.self, from: data)
                                
                UserDefaultsManager.shared.savePersonSeed(seed: persons.info.seed)
                UserDefaultsManager.shared.savePersonPage(page: persons.info.page)
                
                completion(.success(persons.results))
            } catch {
                completion(.failure(.invalidData))
            }
        }.resume()
    }
    
    func fetchContactPersonRx(results: Int) -> Observable<[Person.ContactPerson]> {
        let urlString = String(format: Constants.API.Person.getRandomContactPersons, results)
        return Observable.create { observer in
            guard let url = URL(string: urlString) else {
                observer.onError(APError.invalidURL)
                return Disposables.create()
            }
            
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    observer.onError(APError.unableToComplete)
                    return
                }
                
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    observer.onError(APError.invalidResponse)
                    return
                }
                
                guard let data = data else {
                    observer.onError(APError.invalidData)
                    return
                }
                
                do {
                    let persons = try JSONDecoder().decode(ContactPersonAPIResponse.self, from: data)
                    observer.onNext(persons.results)
                    observer.onCompleted()
                } catch {
                    observer.onError(APError.unableToComplete)
                }
            }
            
            task.resume()
            return Disposables.create {
                task.cancel()
            }
        }
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
    
    private func loadMorePersons(results:Int, completion: @escaping (Result<[Person], APError>) -> Void) {
        guard let retrievedSeed = UserDefaultsManager.shared.loadPersonSeed() else {
            completion(.failure(.unableToComplete))
            return
        }
        
        let nextPage = UserDefaultsManager.shared.loadPersonPage()+1
        
        let urlString = String(format: Constants.API.Person.getMorePersons, nextPage, results, retrievedSeed)
        
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
                UserDefaultsManager.shared.savePersonPage(page: nextPage)
                completion(.success(persons.results))
            } catch {
                completion(.failure(.invalidData))
            }
        }.resume()
    }
    
}
