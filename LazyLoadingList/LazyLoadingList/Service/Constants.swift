//
//  APIConstants.swift
//  LazyLoadingList
//
//  Created by Gerard on 8/23/24.
//

import Foundation
import UIKit

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
    
    struct Screen {
        static let screenWidth = UIScreen.main.bounds.width
        static let screenHeight = UIScreen.main.bounds.height
                
        static let isIPProSize = screenWidth > 375.0
        
        static func sacledSizeH(_ value: CGFloat) -> CGFloat {
            return (((value+15)/812.0)*screenWidth)
        }
    }
}
