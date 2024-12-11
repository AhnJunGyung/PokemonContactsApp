//
//  ViewController.swift
//  PokemonContactsApp
//
//  Created by t2023-m0072 on 12/9/24.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    private var contactsInfo: [ContactsInfo] = []//연락처 구조체
   
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

        let rightButton = UIBarButtonItem(
            title: "추가",
            style: .plain,
            target: self,
            action: #selector(tapRightButton)
        )
        self.navigationItem.rightBarButtonItem = rightButton

    }
    
    @objc
    private func tapRightButton() {
        self.navigationController?.pushViewController(PhoneBookViewController(), animated: true)
    }
    
    //연락처 입력 후 다시 뷰가 열렸을 때
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
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
        
        var data = dataRead()
        
        //연락처 이름순으로 정렬
        data = data.sorted(by: {$0.name < $1.name})
        
        cell.configureCell(data[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return dataRead().count
    }
    
}


//UserDefault 데이터 읽어오기
private func dataRead() -> [ContactsInfo]{
    //Read
    if let savedData = UserDefaults.standard.value(forKey: "contactsArray") as? Data, let contactsInfo = try? PropertyListDecoder().decode([ContactsInfo].self, from: savedData) {
        
        return contactsInfo
    }
    
    return []
}
