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
            static let getMorePersons = "https://randomuser.me/api/?page=%d&results=%d&seed=%@"
        }
    }
    
    struct Defaults {
        static let personsDefaultKey = "savedPersons"
        static let personsSeedDefaultKey = "personsSeed"
        static let personsPageDefaultKey = "personsPage"
    }
}
