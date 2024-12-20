//
//  PhoneBookViewController.swift
//  PokemonContactsApp
//
//  Created by t2023-m0072 on 12/9/24.
//

import UIKit
import SnapKit
import Alamofire

class PhoneBookViewController: UIViewController {
    
    //이미지 url 저장 프로퍼티
    private var pokemonImageUrl: String = ""
    
    //데이터를 전달 받기 위한
    var contactsInfo: [String: ContactsInfo]?
    
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
        
        settingValue()
        configureUI()
        configureNavigationBar()
        
        makeImageButton.addTarget(self, action: #selector(makeRandomImageButton), for: .touchUpInside)
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
        let rightButton = UIBarButtonItem(
            title: "적용",
            style: .plain,
            target: self,
            action: #selector(applyButton)
        )
        
        self.navigationItem.rightBarButtonItem = rightButton
        
    }
    
    @objc
    private func applyButton() {
        if createUserDefaults() {//데이터 저장을 성공한 경우
            //메인화면으로 이동
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc
    private func makeRandomImageButton() {
        fetchPokemonData()
    }
    
    //Alamofire 서버데이터 호출
    private func fetchDataByAlamofire<T: Decodable>(url: URL, completion: @escaping (Result<T, AFError>) -> Void) {
        AF.request(url).responseDecodable(of: T.self) { response in
            completion(response.result)
        }
    }
    
    //서버에서 포켓몬 데이터 호출
    private func fetchPokemonData() {
        //랜덤한 포켓몬 데이터를 가져오도록 url에 랜덤함수 적용
        let urlComponents = URLComponents(string: "https://pokeapi.co/api/v2/pokemon/\(Int.random(in: 0...1000))")
        
        guard let url = urlComponents?.url else {
            print("잘못된 url")
            return
        }
        
        fetchDataByAlamofire(url: url) { [weak self] (result: Result<Welcome, AFError>) in
            guard let self else { return }
            switch result {
            case .success(let result):
                
                //Create 할 때 사용하기 위한 저장용 이미지 URL
                pokemonImageUrl = result.sprites.frontDefault
                
                //이미지 URL 세팅
                guard let imageUrl = URL(string: "\(result.sprites.frontDefault)") else {
                    return
                }
                
                //이미지 로드 작업
                AF.request(imageUrl).responseData { response in
                    if let data = response.data, let image = UIImage(data: data) {
                        
                        //UI작업 메인쓰레드에서 실행
                        DispatchQueue.main.async {
                            self.image.image = image
                        }
                    }
                }
                
            case .failure(let error):
                print("데이터 로드 실패: \(error)")
            }
        }
    }
    
    //데이터 저장
    private func createUserDefaults() -> Bool {
        
        //텍스트뷰에 값 없을 경우 예외처리
        guard !nameTextView.text.isEmpty && !phoneNumberTextView.text.isEmpty else {
            return false
        }
        
        //데이터(이름, 전화번호, 이미지 URL)를 담은 구조체 생성
        let userInfo = ContactsInfo(name: nameTextView.text, phoneNumber: phoneNumberTextView.text, pokemonImage: pokemonImageUrl)
        let dictionaryUserInfo: [String: ContactsInfo] = [userInfo.name: userInfo]
        
        
        //Read
        if let savedData = UserDefaults.standard.value(forKey: "userInfoDicionaty") {//UserDefaults 디코딩
            if let decodedData = try? PropertyListDecoder().decode([[String: ContactsInfo]].self, from: savedData as! Data) {
                
                //decodedData에 값이 존재하는 경우
                var dictionaryArray: [[String: ContactsInfo]] = decodedData
                
                
                //배열에 이름과 같은 값을 가진 배열 제거
                dictionaryArray = dictionaryArray.filter { dictionary in
                    !dictionary.keys.contains(userInfo.name)
                }
                dictionaryArray.append(dictionaryUserInfo)//값을 새로 추가
                
                //배열을 인코딩해서 UserDefaults에 Update
                UserDefaults.standard.set(try? PropertyListEncoder().encode(dictionaryArray), forKey: "userInfoDicionaty")
                
            }
        } else {
            //decodedData에 값이 없는 경우
            let dictionaryArray: [[String: ContactsInfo]] = [dictionaryUserInfo]
            
            //배열을 인코딩해서 UserDefaults에 Create
            UserDefaults.standard.set(try? PropertyListEncoder().encode(dictionaryArray), forKey: "userInfoDicionaty")
        }
        
        return true
    }
    
    private func settingValue() {
        
        if let data = contactsInfo?.values {
            var name: String = ""
            var phoneNumber: String = ""
            var pokemonImage: String = ""
            
            for value in data {
                name = value.name
                phoneNumber = value.phoneNumber
                pokemonImage = value.pokemonImage
            }
            
            nameTextView.text = name
            phoneNumberTextView.text = phoneNumber
            
            //이미지 로드 작업
            AF.request(pokemonImage).responseData { response in
                if let data = response.data, let image = UIImage(data: data) {
                    
                    DispatchQueue.main.async {
                        self.image.image = image
                    }
                }
            }
        }
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        //UI입력 데이터 초기화
        nameTextView.text = nil
        phoneNumberTextView.text = nil
        image.image = nil
        contactsInfo = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        settingValue()
    }
    
    
    override func viewIsAppearing(_ animated: Bool) {
        //메인 뷰에서 셀을 클릭한 경우
        if let data = contactsInfo?.values {
            var name: String = ""
            
            for value in data {
                name = value.name
            }
            self.navigationItem.title = name
            
        } else {//추가 버튼을 클릭한 경우
            self.navigationItem.title = "연락처 추가"
        }
    }
    
}
