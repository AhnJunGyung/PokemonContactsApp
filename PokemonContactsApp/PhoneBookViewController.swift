//
//  PhoneBookViewController.swift
//  PokemonContactsApp
//
//  Created by t2023-m0072 on 12/9/24.
//

import UIKit
import SnapKit

class PhoneBookViewController: UIViewController {
        
    private let image: UIImageView = {
        var image = UIImageView()
        image.layer.cornerRadius = 80 //원형을 만들 경우 : width의 2분의 1
        image.layer.borderWidth = 3
        image.layer.borderColor = UIColor.lightGray.cgColor
        return image
    }()
    
    private let makeImageButton: UIButton = {
        var button = UIButton()
        button.setTitle("랜덤 이미지 생성", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16)
        return button
    }()
    
    private let nameTextView: UITextView = {
        var textView = UITextView()
        textView.font = .systemFont(ofSize: 20)
        textView.layer.cornerRadius = 7
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.lightGray.cgColor
        return textView
    }()
    
    private let phoneNumberTextView: UITextView = {
        var textView = UITextView()
        textView.font = .systemFont(ofSize: 20)
        textView.layer.cornerRadius = 7
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.lightGray.cgColor
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureNavigationBar()
        configureUI()
    }
    
    private func configureUI() {
        view.addSubview(image)
        view.addSubview(makeImageButton)
        view.addSubview(nameTextView)
        view.addSubview(phoneNumberTextView)
        
        image.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(140)
            $0.height.equalTo(160)
            $0.width.equalTo(160)
        }
        
        makeImageButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(image.snp.bottom).offset(10)
        }
        
        nameTextView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(makeImageButton.snp.bottom).offset(30)
            $0.leading.equalToSuperview().inset(20)
            $0.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(40)
        }
        
        phoneNumberTextView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(nameTextView.snp.bottom).offset(10)
            $0.leading.equalToSuperview().inset(20)
            $0.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(40)
        }
        
    }
    
    private func configureNavigationBar() {
        //네비게이션 아이템 생성
        self.navigationItem.title = "연락처 추가"
        self.navigationItem.leftBarButtonItem?.title = "Back"

        let rightButton = UIBarButtonItem(
            title: "적용",
            style: .plain,
            target: self,
            action: #selector(tapRightButton)
        )
        
        self.navigationItem.rightBarButtonItem = rightButton

    }
    
    @objc
    private func tapRightButton() {
        print("적용")//TODO: 적용 기능 개발
    }
    
}
