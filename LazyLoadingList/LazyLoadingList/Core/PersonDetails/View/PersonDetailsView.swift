//
//  PersonDetailsView.swift
//  LazyLoadingList
//
//  Created by Gerard on 8/22/24.
//

import UIKit

class PersonDetailsView: BaseUIView {
    
    private lazy var avatarImg: UIImageView = {
        let img = UIImageView(image: UIImage(named: "avatar_placeholder"))
        return img
    }()
    
    private lazy var fullNameLbl: UILabel = {
        let lbl = UILabel()
        lbl.text = "Max Vestappen"
        return lbl
    }()
    
    
    private lazy var firstName: SingleDetailView = {
        let view = SingleDetailView()
        return view
    }()
    
    
    ///https://dribbble.com/shots/22714476-A-profile-view-screen-with-profile-picture-and-personal-info
    
    override func setup() {
        addSubview(avatarImg)
        avatarImg.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(175)
            make.width.equalToSuperview().multipliedBy(0.3)
            make.height.equalTo(avatarImg.snp.width)
        }
        
        addSubview(fullNameLbl)
        fullNameLbl.snp.makeConstraints { make in
            make.top.equalTo(avatarImg.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
        }
        
        addSubview(firstName)
        firstName.snp.makeConstraints { make in
            make.top.equalTo(fullNameLbl.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalTo(50)
        }
    }
}
