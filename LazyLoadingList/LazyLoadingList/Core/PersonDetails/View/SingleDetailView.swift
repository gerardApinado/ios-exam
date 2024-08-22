//
//  SingleDetailView.swift
//  LazyLoadingList
//
//  Created by Gerard on 8/22/24.
//

import UIKit

class SingleDetailView: BaseUIView {
    
    var data: String? {
        didSet { dataLbl.text = data }
    }
    
    private lazy var titleLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 16, weight: .medium)
        return lbl
    }()
    
    private lazy var dataLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 16)
        return lbl
    }()
    
    init(title:String) {
        super.init(frame: .zero)
        titleLbl.text = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setup() {
        let bgView = UIView()
        bgView.layer.borderWidth = 1
        bgView.layer.borderColor = UIColor.lightGray.cgColor
        bgView.layer.cornerRadius = 5
        addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.65)
            make.bottom.left.right.equalToSuperview()
        }
        
        addSubview(titleLbl)
        titleLbl.snp.makeConstraints { make in
            make.bottom.equalTo(bgView.snp.top).offset(-2)
            make.left.equalToSuperview()
        }
        
        bgView.addSubview(dataLbl)
        dataLbl.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(7)
        }
    }
}
