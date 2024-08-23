//
//  PersonDetailsView.swift
//  LazyLoadingList
//
//  Created by Gerard on 8/22/24.
//

import UIKit
import SnapKit

class PersonDetailsView: BaseUIView {
    
    private lazy var topBgView: UIView = {
        let view = UIView()
        view.backgroundColor = .randomColor()
        return view
    }()
    
    private lazy var avatarImg: UIImageView = {
        let img = UIImageView()
        img.layer.borderWidth = 5
        img.layer.borderColor = UIColor.white.cgColor
        return img
    }()
    
    private lazy var fullNameLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 22, weight: .bold)
        return lbl
    }()
    
    private lazy var firstName: SingleDetailView = {
        let view = SingleDetailView(title: "Firstname")
        return view
    }()
    
    private lazy var lastName: SingleDetailView = {
        let view = SingleDetailView(title: "Lastname")
        return view
    }()
    
    private lazy var birthdate: SingleDetailView = {
        let view = SingleDetailView(title: "Birthday")
        return view
    }()
    
    private lazy var age: SingleDetailView = {
        let view = SingleDetailView(title: "Age")
        return view
    }()
    
    private lazy var email: SingleDetailView = {
        let view = SingleDetailView(title: "Email")
        return view
    }()
    
    private lazy var phone: SingleDetailView = {
        let view = SingleDetailView(title: "Phone")
        return view
    }()
    
    private lazy var contactPerson: SingleDetailView = {
        let view = SingleDetailView(title: "Contact Person")
        return view
    }()
    
    private lazy var contactPersonPhone: SingleDetailView = {
        let view = SingleDetailView(title: "Contact Person Phone")
        return view
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        avatarImg.layer.cornerRadius = avatarImg.frame.size.height / 2
        avatarImg.clipsToBounds = true
    }
    
    //TODO: change the details to UITableView
    override func setup() {
        addSubview(topBgView)
        topBgView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.2)
        }
        
        addSubview(avatarImg)
        avatarImg.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
//            make.top.equalToSuperview().offset(155)
            make.centerY.equalTo(topBgView.snp.bottom)
            make.width.equalToSuperview().multipliedBy(0.3)
            make.height.equalTo(avatarImg.snp.width)
        }
        
        addSubview(fullNameLbl)
        fullNameLbl.snp.makeConstraints { make in
            make.top.equalTo(avatarImg.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
        }
        
        let configureConstraints: (ConstraintMaker) -> Void = { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.85)
            make.height.equalTo(50)
        }
        
        addSubview(firstName)
        firstName.snp.makeConstraints { make in
            make.top.equalTo(fullNameLbl.snp.bottom).offset(24)
            configureConstraints(make)
        }
        
        addSubview(lastName)
        lastName.snp.makeConstraints { make in
            make.top.equalTo(firstName.snp.bottom).offset(14)
            configureConstraints(make)
        }
        
        addSubview(birthdate)
        birthdate.snp.makeConstraints { make in
            make.top.equalTo(lastName.snp.bottom).offset(14)
            make.left.equalTo(lastName)
            make.width.equalToSuperview().multipliedBy(0.42)
            make.height.equalTo(50)
        }
        
        addSubview(age)
        age.snp.makeConstraints { make in
            make.top.equalTo(lastName.snp.bottom).offset(14)
            make.left.equalTo(birthdate.snp.right).offset(5)
            make.trailing.equalTo(lastName)
            make.height.equalTo(50)
        }
        
        addSubview(email)
        email.snp.makeConstraints { make in
            make.top.equalTo(age.snp.bottom).offset(14)
            configureConstraints(make)
        }
        
        addSubview(phone)
        phone.snp.makeConstraints { make in
            make.top.equalTo(email.snp.bottom).offset(14)
            configureConstraints(make)
        }
        
        addSubview(contactPerson)
        contactPerson.snp.makeConstraints { make in
            make.top.equalTo(phone.snp.bottom).offset(14)
            configureConstraints(make)
        }
        
        addSubview(contactPersonPhone)
        contactPersonPhone.snp.makeConstraints { make in
            make.top.equalTo(contactPerson.snp.bottom).offset(14)
            configureConstraints(make)
        }
    }
    
    func configDetails(data: Person){
        // load avatar img from cache or api
        avatarImg.loadImageUsingCache(withUrl: data.picture.large, placeholderImage: UIImage(named: "avatar_placeholder"))
        fullNameLbl.text        = "\(data.name.first) \(data.name.last)"
        firstName.data          = data.name.first
        lastName.data           = data.name.last
        birthdate.data          = dateStringToDate(data.dob.date)
        age.data                = "\(data.dob.age)" // must be derived from brithdate
        email.data              = data.email
        phone.data              = data.phone
        contactPerson.data      = "\(data.contactPerson?.name?.first ?? "") \(data.contactPerson?.name?.last ?? "")"
        contactPersonPhone.data = data.contactPerson?.phone
    }
    
    private func dateStringToDate(_ dateString: String) -> String {
        let isoDateFormatter = DateFormatter()
        isoDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        isoDateFormatter.timeZone = TimeZone(abbreviation: "UTC")

        guard let date = isoDateFormatter.date(from: dateString) else {
            print("Failed to parse date")
            return ""
        }

        let dateOnlyFormatter = DateFormatter()
        dateOnlyFormatter.dateStyle = .medium
        dateOnlyFormatter.timeStyle = .none
        dateOnlyFormatter.timeZone = TimeZone.current

        let dateOnlyString = dateOnlyFormatter.string(from: date)
        return dateOnlyString
    }
}
