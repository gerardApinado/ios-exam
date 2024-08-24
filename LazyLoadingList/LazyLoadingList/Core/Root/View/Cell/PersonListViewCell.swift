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
        lbl.font = .systemFont(ofSize: 16)
        lbl.adjustsFontSizeToFitWidth = true
        return lbl
    }()
    
    private lazy var emailLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 16)
        lbl.adjustsFontSizeToFitWidth = true
        return lbl
    }()
    
    private lazy var fullnameLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 18, weight: .semibold)
        lbl.adjustsFontSizeToFitWidth = true
        return lbl
    }()
    
    private lazy var avatarImg: UIImageView = {
        let view = UIImageView()
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
            make.height.equalToSuperview().multipliedBy(0.85)
            make.width.equalTo(avatarImg.snp.height)
        }
        
        addSubview(fullnameLbl)
        fullnameLbl.snp.makeConstraints { make in
            make.left.equalTo(avatarImg.snp.right).offset(10)
            make.top.equalTo(avatarImg)
            make.right.equalToSuperview().offset(-1)
        }
        
        addSubview(emailLbl)
        emailLbl.snp.makeConstraints { make in
            make.left.equalTo(fullnameLbl)
            make.top.equalTo(fullnameLbl.snp.bottom)
            make.right.equalToSuperview().offset(-1)
        }
        
        addSubview(phoneLbl)
        phoneLbl.snp.makeConstraints { make in
            make.left.equalTo(emailLbl)
            make.top.equalTo(emailLbl.snp.bottom)
            make.right.equalToSuperview().offset(-1)
        }
    }
    
    func configCell(data: Person) {
        avatarImg.loadImageUsingCache(withUrl: data.picture.large, placeholderImage: UIImage(named: "avatar_placeholder"))
        fullnameLbl.text = "\(data.name.first) \(data.name.last)"
        emailLbl.text = data.email
        phoneLbl.text = data.phone
    }
    
}
