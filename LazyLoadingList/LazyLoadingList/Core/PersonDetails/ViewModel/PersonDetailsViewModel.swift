//
//  PersonDetailsViewModel.swift
//  LazyLoadingList
//
//  Created by Gerard on 8/25/24.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class PersonDetailsViewModel {
    var personRx: BehaviorRelay<Person>?
    
    func setPersonData(data: Person){
        personRx = BehaviorRelay(value: data)
    }
}
