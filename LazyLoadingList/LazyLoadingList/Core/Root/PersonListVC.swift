//
//  ViewController.swift
//  LazyLoadingList
//
//  Created by Gerard on 8/22/24.
//

import UIKit
import SnapKit

class PersonListVC: UIViewController {
    
    private lazy var contentView: PersonListView = {
        let view = PersonListView()
        view.delegate = self
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        title = "Persons List"
        
        let backButton = UIBarButtonItem()
        backButton.title = title
        navigationItem.backBarButtonItem = backButton
        
        view = contentView
    }

}

extension PersonListVC: PersonListViewDelegate {
    // must handled by the coordinator - MVVMC
    func didTapPerson(_ view: PersonListView) {
        let nextViewController = PersonDetailsVC()
        navigationController?.pushViewController(nextViewController, animated: true)
    }
}

