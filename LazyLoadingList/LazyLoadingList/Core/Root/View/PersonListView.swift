//
//  PersonListView.swift
//  LazyLoadingList
//
//  Created by Gerard on 8/22/24.
//

import UIKit

protocol PersonListViewDelegate: AnyObject {
    func didTapPerson(_ view:PersonListView, data: Person)
}

class PersonListView: BaseUIView {
    
    weak var delegate: PersonListViewDelegate?
    private var persons : [Person] = []
    
    private lazy var table: UITableView = {
        let tbl = UITableView()
        tbl.register(PersonListViewCell.self, forCellReuseIdentifier: "cell")
        tbl.delegate = self
        tbl.dataSource = self
        tbl.separatorStyle = .none
        return tbl
    }()

    override func setup() {
        addSubview(table)
        table.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
    }
    
    func configPersonList(data: [Person]){
        persons = data
        table.reloadData()
    }
}

extension PersonListView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return persons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PersonListViewCell
        cell.backgroundColor = indexPath.row%2 == 0 ? .lightGray.withAlphaComponent(0.5) : .white
        cell.configCell(data: persons[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = tableView.frame.size.height/10
        return height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didTapPerson(self, data: persons[indexPath.row])
    }
}

extension PersonListView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let rowHeight = self.table.frame.size.height/10
        let tableHeight = table.bounds.size.height
        let contentHeight = table.contentSize.height
        let contentOffsetY = scrollView.contentOffset.y
        
        if(contentOffsetY+tableHeight >= contentHeight){
            // Load only once
            print("DEBUG: Load More Person")
        }
    }
}
