//
//  PersonDetailsVC.swift
//  LazyLoadingList
//
//  Created by Gerard on 8/22/24.
//

import UIKit
import RxSwift
import RxCocoa

class PersonDetailsVC: UIViewController {
    
    private var viewModel = PersonDetailsViewModel()
    var coordinator: AppCoordinator?
    private let disposeBag = DisposeBag()
    
    private lazy var contentView: PersonDetailsView = {
        let view = PersonDetailsView()
        view.delegate = self
        return view
    }()
    
    init(data: Person) {
        super.init(nibName: nil, bundle: nil)
        viewModel.setPersonData(data: data)
    
        viewModel.personRx?.subscribe(onNext: { [weak self] person in
            self?.contentView.configDetails(data: person)
        }).disposed(by: disposeBag)
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
