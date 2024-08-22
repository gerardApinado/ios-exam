//
//  PersonListViewCell.swift
//  LazyLoadingList
//
//  Created by Gerard on 8/22/24.
//

import UIKit
import SnapKit

class PersonListViewCell: UITableViewCell {
    
    private lazy var phoneLbl: UILabel = {
        let lbl = UILabel()
        lbl.text = "+1234567890"
        return lbl
    }()
    
    private lazy var emailLbl: UILabel = {
        let lbl = UILabel()
        lbl.text = "max@email.com"
        return lbl
    }()
    
    private lazy var fullnameLbl: UILabel = {
        let lbl = UILabel()
        lbl.text = "Max Vestappen"
        return lbl
    }()
    
    private lazy var avatarImg: UIImageView = {
        let view = UIImageView(image: UIImage(named: "avatar_placeholder"))
        return view
    }()
    

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(){
        addSubview(avatarImg)
        avatarImg.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.9)
            make.width.equalTo(avatarImg.snp.height)
        }
        
        addSubview(fullnameLbl)
        fullnameLbl.snp.makeConstraints { make in
            make.left.equalTo(avatarImg.snp.right).offset(10)
            make.top.equalTo(avatarImg)
        }
        
        addSubview(emailLbl)
        emailLbl.snp.makeConstraints { make in
            make.left.equalTo(fullnameLbl)
            make.top.equalTo(fullnameLbl.snp.bottom)
        }
        
        addSubview(phoneLbl)
        phoneLbl.snp.makeConstraints { make in
            make.left.equalTo(fullnameLbl)
            make.top.equalTo(emailLbl.snp.bottom)
        }
    }
    
}
