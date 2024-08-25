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
    
    private var personsRx : BehaviorRelay<[Person]> = BehaviorRelay(value: [])
    private var contactPersonRx : BehaviorRelay<[Person.ContactPerson]> = BehaviorRelay(value: [])
    
    private var disposeBag = DisposeBag()
    
    //MARK: public methods    
    func fetchCompletePersonsDetailsRx(results: Int) -> Observable<[Person]> {
        return Observable.zip(
                self.fetchPersonsRx(results: results)
                    .observe(on: MainScheduler.instance)
                    .catchAndReturn([]),
                self.fetchContactPersonRx(results: results)
                    .observe(on: MainScheduler.instance)
                    .catchAndReturn([])
            )
            .map { persons, contacts in
                // Combine contactPerson to Persons
                var updatedPersons = persons
                for i in 0..<updatedPersons.count {
                    updatedPersons[i].contactPerson = contacts[i]
                }
                return updatedPersons
            }
            .do(onNext: { [weak self] combinedPersons in
                self?.personsRx.accept(combinedPersons)
            })
    }
    
    func loadMoreCompletePersonsDetailsRx(results: Int, page: Int) -> Observable<[Person]> {
        return Observable.zip(
                self.loadMorePersonsRx(results: results, page: page)
                    .observe(on: MainScheduler.instance)
                    .catchAndReturn([]),
                self.fetchContactPersonRx(results: results)
                    .observe(on: MainScheduler.instance)
                    .catchAndReturn([])
            )
            .map { persons, contacts in
                // Combine contactPerson to Persons
                var updatedPersons = persons
                for i in 0..<updatedPersons.count {
                    updatedPersons[i].contactPerson = contacts[i]
                }
                return updatedPersons
            }
            .do(onNext: { [weak self] combinedPersons in
                self?.personsRx.accept(combinedPersons)
            })
    }
    
    // MARK: RxSwift
    private func fetchPersonsRx(results: Int) -> Observable<[Person]> {
        let urlString = String(format: Constants.API.Person.getNumberOfPersons, results)
        
        return Observable.create { observer in
            guard let url = URL(string: urlString) else {
                observer.onError(APError.invalidURL)
                return Disposables.create()
            }
            
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if error != nil {
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
    
    private func fetchContactPersonRx(results: Int) -> Observable<[Person.ContactPerson]> {
        let urlString = String(format: Constants.API.Person.getRandomContactPersons, results)
        return Observable.create { observer in
            guard let url = URL(string: urlString) else {
                observer.onError(APError.invalidURL)
                return Disposables.create()
            }
            
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if error != nil {
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
    
    private func loadMorePersonsRx(results: Int, page: Int) -> Observable<[Person]> {
        return Observable.create { observer in
            guard let retrievedSeed = UserDefaultsManager.shared.loadPersonSeed() else {
                observer.onError(APError.unableToComplete)
                return Disposables.create()
            }
            
            let urlString = String(format: Constants.API.Person.getMorePersons, page, results, retrievedSeed)
            
            guard let url = URL(string: urlString) else {
                observer.onError(APError.invalidURL)
                return Disposables.create()
            }
            
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if error != nil {
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
                    // fetch 10 Pesons
                    let persons = try JSONDecoder().decode(PersonAPIResponse.self, from: data)
                                                        
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
}
