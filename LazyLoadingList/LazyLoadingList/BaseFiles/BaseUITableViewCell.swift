//
//  BaseUITableViewCell.swift
//  LazyLoadingList
//
//  Created by Akkram Bederi on 8/22/24.
//

import UIKit

class BaseUITableViewCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        
    }

}
