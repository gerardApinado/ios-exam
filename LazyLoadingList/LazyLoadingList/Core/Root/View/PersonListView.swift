//
//  PersonListView.swift
//  LazyLoadingList
//
//  Created by Gerard on 8/22/24.
//

import UIKit

protocol PersonListViewDelegate: AnyObject {
    func didTapPerson(_ view:PersonListView)
}

class PersonListView: UIView {
    
    weak var delegate: PersonListViewDelegate?
    
    private lazy var table: UITableView = {
        let tbl = UITableView()
        tbl.register(PersonListViewCell.self, forCellReuseIdentifier: "cell")
        tbl.delegate = self
        tbl.dataSource = self
        return tbl
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(table)
        table.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PersonListView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PersonListViewCell
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didTapPerson(self)
    }
    
}
