//
//  PersonListViewModel.swift
//  LazyLoadingList
//
//  Created by Gerard on 8/23/24.
//

import Foundation
import RxSwift
import RxCocoa

class PersonListViewModel {
    
    let service = PersonService()
    var personsRx: BehaviorRelay<[Person]> = BehaviorRelay(value: [])
    var disposeBag = DisposeBag()
    
    var page: Int = 1
    var isFetchingMoreData: Bool = false
    
    func fetchPersonsRx() {
        if UserDefaultsManager.shared.loadPersonFromUserDefaults() != nil {
            if let localPersons = UserDefaultsManager.shared.loadPersonFromUserDefaults() {
                let personsToAccept = localPersons.count >= 10
                ? Array(localPersons.prefix(10))
                : Array(localPersons.prefix(localPersons.count))
                
                self.personsRx.accept(personsToAccept)
                self.page = 1 // reset paging to 1
            }
            return
        }
        
        service.fetchCompletePersonsDetailsRx(results: 30)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] persons in
                UserDefaultsManager.shared.savePersonToUserDefaults(person: persons)
                let personsToAccept = persons.count >= 10
                ? Array(persons.prefix(10))
                : Array(persons.prefix(persons.count))
                self?.personsRx.accept(personsToAccept)
             })
            .disposed(by: disposeBag)
    }
    
    func refreshPersonsRx(completion: @escaping () -> Void) {
        if UserDefaultsManager.shared.loadPersonFromUserDefaults() == nil {
            return
        }
        
        UserDefaultsManager.shared.removePersons()
        UserDefaultsManager.shared.removePersonSeed()
           
        service.fetchCompletePersonsDetailsRx(results: 30)
            .observe(on: MainScheduler.instance)
            .subscribe(
                onNext: { [weak self] persons in
                UserDefaultsManager.shared.savePersonToUserDefaults(person: persons)
                let personsToAccept = persons.count >= 10
                ? Array(persons.prefix(10))
                : Array(persons.prefix(persons.count))
                self?.personsRx.accept(personsToAccept)
                },
                onCompleted: {
                    self.page = 1
                    completion()
                }
            )
            .disposed(by: disposeBag)
    }
    
    func loadMorePersonsRx(completion: @escaping () -> Void) {
        // local loading
        if let localPersons = UserDefaultsManager.shared.loadPersonFromUserDefaults(),
           personsRx.value.count != localPersons.count {
            let nextPageRx = self.page+1
            let results = 10*nextPageRx
            self.personsRx.accept(Array(localPersons.prefix(results)))
            self.page = nextPageRx
            completion()
        } else {
        // remote loading
            let nextPageRx = self.page+1
            service.loadMoreCompletePersonsDetailsRx(results: 10, page: nextPageRx)
                .observe(on: MainScheduler.instance)
                .subscribe(
                    onNext: { [weak self] persons in
                        UserDefaultsManager.shared.appendPersonsToUserDefaults(newPersons: persons)
                        if let loadedPersons = UserDefaultsManager.shared.loadPersonFromUserDefaults() {
                            self?.personsRx.accept(loadedPersons)
                        }
                    },
                    onCompleted: {
                        self.page = nextPageRx
                        completion()
                    }
                )
                .disposed(by: disposeBag)
        }
    }
}
