//
//  ViewController.swift
//  PokemonContactsApp
//
//  Created by t2023-m0072 on 12/9/24.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
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
            $0.top.equalToSuperview().offset(130)//Lv3 추가
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
        //TODO: 데이터 작업
        cell.configureCell(ContactsInfo.sampleData[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ContactsInfo.sampleData.count//TODO: 데이터 작업
    }
    
}
