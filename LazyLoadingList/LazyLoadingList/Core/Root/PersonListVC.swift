//
//  ViewController.swift
//  LazyLoadingList
//
//  Created by Gerard on 8/22/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class PersonListVC: UIViewController {
    
    var coordinator : AppCoordinator?
    private var viewModel = PersonListViewModel()
    private let disposeBag = DisposeBag()
    private let refreshControl = UIRefreshControl()
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.register(PersonListViewCell.self, forCellReuseIdentifier: "cell")
        table.rx.setDelegate(self).disposed(by: disposeBag)
        refreshControl.addTarget(self, action: #selector(didRefreshTable), for: .valueChanged)
        table.refreshControl = refreshControl
        table.separatorStyle = .none
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Persons List"
        let backButton = UIBarButtonItem()
        backButton.title = title
        navigationItem.backBarButtonItem = backButton
        
        setupUI()
        bindViewModel()
        viewModel.fetchPersonsRx()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func bindViewModel() {
        viewModel.personsRx
            .bind(to: tableView.rx.items(cellIdentifier: "cell", cellType: PersonListViewCell.self)) { index, person, cell in
                cell.configCell(data: person)
        }.disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .subscribe { [weak self] indexPath in
                self?.handleRowSelection(at: indexPath)
            }
            .disposed(by: disposeBag)
    }
    
    private func handleRowSelection(at indexPath: IndexPath) {
        coordinator?.routeToPersonDetails(data: viewModel.personsRx.value[indexPath.row])
    }

}

//MARK: action
extension PersonListVC {
    @objc func didRefreshTable(){
        viewModel.refreshPersonsRx() { [weak self] in
            self?.refreshControl.endRefreshing()
        }
    }
}

//MARK: delegate
extension PersonListVC: UITableViewDelegate, UIScrollViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height / 10
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let tableHeight = tableView.bounds.size.height
        let contentHeight = tableView.contentSize.height
        let contentOffsetY = scrollView.contentOffset.y
        
        if(contentOffsetY+tableHeight > contentHeight && contentHeight > 0 && contentOffsetY > 0){
            if !viewModel.isFetchingMoreData {
                viewModel.isFetchingMoreData = true
                
                viewModel.loadMorePersonsRx { [weak self] in
                    self?.viewModel.isFetchingMoreData = false
                }
            }
        }
    }
}

