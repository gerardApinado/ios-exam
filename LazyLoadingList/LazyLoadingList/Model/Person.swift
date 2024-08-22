//
//  Person.swift
//  LazyLoadingList
//
//  Created by Gerard on 8/22/24.
//

import Foundation
import UIKit

struct Person : Codable {
    let firstName: String
    let lastName: String
    let birthday: String
    let age: Int
    let email: String
    let phone: String
    let address: String
    let contactPerson: String
    let contactPersonPhone: String
}

class SamplePersonDetails {
    static let singlePerson = Person(firstName: "Max",
                              lastName: "Verstappen",
                              birthday: "1998-09-08",
                              age: 24,
                              email: "email@emial.com",
                              phone: "+1234567890",
                              address: "Tondo, Manila",
                              contactPerson: "Mary Loi",
                              contactPersonPhone: "+1234567890")
}
