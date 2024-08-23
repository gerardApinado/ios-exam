//
//  ViewController.swift
//  LazyLoadingList
//
//  Created by Gerard on 8/22/24.
//

import UIKit
import SnapKit

class PersonListVC: UIViewController {
    
    var coordinator : AppCoordinator?
    private var viewModel = PersonListViewModel()
    
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
        
        viewModel.reloadData = {
            DispatchQueue.main.async { [weak self] in
                if let persons = self?.viewModel.persons {
                    self?.contentView.configPersonList(data: persons)
                }
            }
        }
        viewModel.fetchPersons()
        
        view = contentView
    }

}

extension PersonListVC: PersonListViewDelegate {
    func willLoadMorePersons(_ view: PersonListView, completion: @escaping () -> Void) {
        viewModel.loadMorePersons {
            print("DEBUG: Loaded +10")
            completion()
        }
    }
    
    func didRefreshTable(_ view: PersonListView) {
        viewModel.refreshPersons()
        viewModel.reloadData = {
            DispatchQueue.main.async { [weak self] in
                if let persons = self?.viewModel.persons {
                    self?.contentView.configPersonList(data: persons)
                }
            }
        }
        
        contentView.refreshControl.endRefreshing()
    }
    
    func didTapPerson(_ view: PersonListView, data: Person) {
        coordinator?.routeToPersonDetails(data: data)
    }
}

