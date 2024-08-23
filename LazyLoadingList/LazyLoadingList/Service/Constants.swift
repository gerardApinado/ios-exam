//
//  APIConstants.swift
//  LazyLoadingList
//
//  Created by Gerard on 8/23/24.
//

import Foundation

struct Constants {
    struct API {
        struct Person {
            static let getNumberOfPersons = "https://randomuser.me/api/?results=%d"
            static let getRandomContactPersons = "https://randomuser.me/api/?results=%d&inc=name,phone"
        }
    }
    
    struct Defaults {
        static let personsDefaultKey = "savedPersons"
    }
}
