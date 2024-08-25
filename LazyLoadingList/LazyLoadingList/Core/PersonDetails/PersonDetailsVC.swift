//
//  PersonDetailsVC.swift
//  LazyLoadingList
//
//  Created by Gerard on 8/22/24.
//

import UIKit

class PersonDetailsVC: UIViewController {
    
    var coordinator: AppCoordinator?
    
    private lazy var contentView: PersonDetailsView = {
        let view = PersonDetailsView()
        view.delegate = self
        return view
    }()
    
    init(data: Person) {
        super.init(nibName: nil, bundle: nil)
        contentView.configDetails(data: data)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Details"
        
        view = contentView
    }

}

extension PersonDetailsVC: PersonDetailsViewDelegate {
    func didTapAvatar(_ view: PersonDetailsView) {
        coordinator?.popCurrentViewController()
    }
}
