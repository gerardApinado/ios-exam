//
//  UIColor+Extension.swift
//  LazyLoadingList
//
//  Created by Gerard on 8/22/24.
//

import Foundation
import UIKit

extension UIColor {
    static func randomColor() -> UIColor {
        let red = CGFloat.random(in: 0...1)
        let green = CGFloat.random(in: 0...1)
        let blue = CGFloat.random(in: 0...1)
        let alpha = CGFloat.random(in: 0.5...1.0)
        
        let randomColor = UIColor.init(red: red, green: green, blue: blue, alpha: alpha)
        
        return randomColor
    }
}
