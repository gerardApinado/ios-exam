//
//  PersonListViewCell.swift
//  LazyLoadingList
//
//  Created by Gerard on 8/22/24.
//

import UIKit
import SnapKit

class PersonListViewCell: BaseUITableViewCell {
    
    private lazy var phoneLbl: UILabel = {
        let lbl = UILabel()
        lbl.text = "+1234567890"
        lbl.font = .systemFont(ofSize: 16)
        return lbl
    }()
    
    private lazy var emailLbl: UILabel = {
        let lbl = UILabel()
        lbl.text = "max@email.com"
        lbl.font = .systemFont(ofSize: 16)
        return lbl
    }()
    
    private lazy var fullnameLbl: UILabel = {
        let lbl = UILabel()
        lbl.text = "Max Vestappen"
        lbl.font = .systemFont(ofSize: 18, weight: .semibold)
        return lbl
    }()
    
    private lazy var avatarImg: UIImageView = {
        let view = UIImageView(image: UIImage(named: "avatar_placeholder"))
        return view
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        avatarImg.layer.cornerRadius = avatarImg.frame.size.height / 2
        avatarImg.clipsToBounds = true
    }
    
    override func setupUI(){
        selectionStyle = .none
        
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
    
    func configCell(data: Person) {
        
    }
    
}
