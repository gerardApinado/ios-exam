//
//  PersonDetailsVC.swift
//  LazyLoadingList
//
//  Created by Gerard on 8/22/24.
//

import UIKit

class PersonDetailsVC: UIViewController {
    
    private lazy var contentView: PersonDetailsView = {
        let view = PersonDetailsView()
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Details"
        
        view = contentView
        contentView.configDetails(data: PersonMockData.singlePerson)
    }

}
