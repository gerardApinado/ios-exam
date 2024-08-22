//
//  SingleDetailView.swift
//  LazyLoadingList
//
//  Created by Gerard on 8/22/24.
//

import UIKit

class SingleDetailView: BaseUIView {
    
    private lazy var titleLbl: UILabel = {
        let lbl = UILabel()
        lbl.text = "Firstname"
        return lbl
    }()
    
    private lazy var dataLbl: UILabel = {
        let lbl = UILabel()
        lbl.text = "Max"
        return lbl
    }()

    override func setup() {
        let bgView = UIView()
        bgView.layer.borderWidth = 1
        addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.4)
            make.bottom.left.right.equalToSuperview()
        }
        
        addSubview(titleLbl)
        titleLbl.snp.makeConstraints { make in
            make.bottom.equalTo(bgView.snp.top).offset(-6)
            make.left.equalToSuperview()
        }
        
        bgView.addSubview(dataLbl)
        dataLbl.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(10)
        }
    }
}
