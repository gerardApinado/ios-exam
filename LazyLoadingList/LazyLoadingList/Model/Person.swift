//
//  Person.swift
//  LazyLoadingList
//
//  Created by Gerard on 8/22/24.
//

import Foundation
import UIKit

struct Person : Codable {
    struct Name: Codable {
        let first: String
        let last: String
    }
        
    struct Location: Codable {
        struct Street: Codable {
            let number: Int
            let name: String
        }
        let street: Street
        let city: String
        let state: String
        let country: String
    }
    
    struct Picture: Codable {
        let large: String
    }
    
    struct Dob: Codable {
        let date: String
        let age: Int
    }
    
    struct ContactPerson: Codable {
        let name: Name?
        let phone: String?
    }
    
    let name: Name
    let location: Location
    let email: String
    let phone: String
    let dob: Dob
    let picture: Picture
    
    var contactPerson: ContactPerson?
}

struct Info: Codable {
    let seed : String
    let page : Int
}

struct PersonAPIResponse: Codable {
    let results: [Person]
    let info: Info
}

struct ContactPersonAPIResponse: Codable {
    let results: [Person.ContactPerson]
}

struct PersonMockData {
    static let singlePerson = Person(
        name: Person.Name(first: "Max", last: "Verstappen"),
        location: Person.Location(
            street: Person.Location.Street(number: 99, name: "Gil Tulog"),
            city: "Pasay City",
            state: "Metro Manila",
            country: "Philippines"),
        email: "email@email.com",
        phone: "+1234567890",
        dob: Person.Dob(
            date: "2000-09-08T11:47:11.796Z",
            age: 50),
        picture: Person.Picture(large: "https://randomuser.me/api/portraits/men/61.jpg"),
        contactPerson: Person.ContactPerson(
            name: Person.Name(first: "Mary Loi", last: "Yves"),
            phone: "+0987654321")
    )
}
