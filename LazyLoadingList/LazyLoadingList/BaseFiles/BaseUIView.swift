//
//  BaseUIView.swift
//  LazyLoadingList
//
//  Created by Gerard on 8/22/24.
//

import UIKit

class BaseUIView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal func setup() {
        
    }

}
