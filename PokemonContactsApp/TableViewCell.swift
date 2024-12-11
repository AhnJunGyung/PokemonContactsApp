//
//  TableViewCell.swift
//  PokemonContactsApp
//
//  Created by t2023-m0072 on 12/9/24.
//

import UIKit
import SnapKit
import Alamofire

class TableViewCell: UITableViewCell {
    
    static let id = "TableViewCell"
    
    private let nameLabel: UILabel = {
        var label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 20)
        return label
    }()
    
    private let phoneNumberLabel: UILabel = {
        var label = UILabel()
        label.font = .systemFont(ofSize: 20)
        return label
    }()
    
    private let image: UIImageView = {
        var image = UIImageView()
        image.layer.cornerRadius = 35 //원형을 만들 경우 : width의 2분의 1
        image.layer.borderWidth = 2
        image.layer.borderColor = UIColor.lightGray.cgColor
        return image
    }()
    
    //테이블뷰의 style과 id로 초기화를 할 때 사용하는 코드
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    //인터페이스빌더(스토리보드, XIB 등)로 초기화 할때 사용
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented") //fatalError : 사용하지 않음을 명시
    }
    
    private func configureUI() {
        [
            image,
            nameLabel,
            phoneNumberLabel
        ].forEach { contentView.addSubview($0) }
        
        image.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(70)
            $0.height.equalTo(70)
        }
        
        nameLabel.snp.makeConstraints {
            $0.leading.equalTo(image.snp.trailing).offset(20)
            $0.centerY.equalTo(image)
        }
        
        phoneNumberLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(10)
            $0.centerY.equalTo(image)
        }
    }
    
    public func configureCell(_ contactsInfo: ContactsInfo) {

        nameLabel.text = contactsInfo.name
        phoneNumberLabel.text = contactsInfo.phoneNumber
        
        //이미지 URL 세팅
        //Alamofire를 통해 URL에서 이미지로 변환
        AF.request(contactsInfo.pokemonImage).responseData { response in
            if let data = response.data, let image = UIImage(data: data) {
                
                //UI작업 메인쓰레드에서 실행
                DispatchQueue.main.async {
                    self.image.image = image
                }
            }
        }
        
    }
    
}
