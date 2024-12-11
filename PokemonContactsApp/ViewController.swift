//
//  ViewController.swift
//  PokemonContactsApp
//
//  Created by t2023-m0072 on 12/9/24.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    //연락처 구조체
    private var contactsInfo: [[String: ContactsInfo]]?
    
    //뷰컨트롤러 최초 한 번 생성(뷰 재활용)
    private let phoneBookViewController = PhoneBookViewController()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self //테이블뷰 속성 세팅을 self(ViewController)에 위임
        tableView.dataSource = self //데이터소스를 self(ViewController)에서 세팅
        tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.id)
        return tableView
    }()
    
    //네비게이션 바
    let navigationBar: UINavigationBar = {
        let navigationBar = UINavigationBar()
        return navigationBar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataRead()
        configureNavigationBar()
        configureUI()
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        view.addSubview(navigationBar)
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(130)
            $0.bottom.equalToSuperview()
            $0.leading.equalToSuperview().inset(20)
            $0.trailing.equalToSuperview().inset(20)
        }
    }
    
    private func configureNavigationBar() {
        //네비게이션 아이템 생성
        self.navigationItem.title = "친구 목록"
        
        let addButton = UIBarButtonItem(
            title: "추가",
            style: .plain,
            target: self,
            action: #selector(tapAddButton)
        )
        self.navigationItem.rightBarButtonItem = addButton
        
    }
    
    @objc
    private func tapAddButton() {
        self.navigationController?.pushViewController(phoneBookViewController, animated: true)
    }
    
    //연락처 입력 후 다시 뷰가 열렸을 때
    override func viewIsAppearing(_ animated: Bool) {
        dataRead()
        tableView.reloadData()
    }
    
    //UserDefault 데이터 읽어오기
    private func dataRead(){
        //Read
        if let savedData = UserDefaults.standard.value(forKey: "userInfoDicionaty") {//UserDefaults 디코딩
            if let decodedData = try? PropertyListDecoder().decode([[String: ContactsInfo]].self, from: savedData as! Data) {
                
                //데이터 이름 기준으로 오름차순 정렬
                let sortedData = decodedData.sorted(by: {
                    if let data1 = $0.values.first, let data2 = $1.values.first  {
                        return data1.name < data2.name
                    }
                    return false
                })
                
                let dictionaryArray: [[String: ContactsInfo]] = sortedData

                contactsInfo = dictionaryArray
            }
        }
    }
    
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80 //셀 높이
    }
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.id) as? TableViewCell else {
            return UITableViewCell()
        }
        if let info = contactsInfo?[indexPath.row] {
            cell.configureCell(info)
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let contactsCount = contactsInfo {
            return contactsCount.count
        } else {
            return 0
        }
    }
    
    //셀 클릭시 뷰 이동
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //phoneBookViewController에 클릭한 셀 데이터 전달
        if let info = contactsInfo?[indexPath.row] {
            phoneBookViewController.contactsInfo = info
        }
        
        self.navigationController?.pushViewController(phoneBookViewController, animated: true)
    }
    
}



