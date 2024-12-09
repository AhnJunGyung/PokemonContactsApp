//
//  ContactsInfo.swift
//  PokemonContactsApp
//
//  Created by t2023-m0072 on 12/9/24.
//

import UIKit

class ContactsInfo {
    var image: UIImage? {
        return UIImage(named: name)
    }
    var name: String
    var phoneNumber: String
    
    init(name: String, phoneNumber: String) {
        self.name = name
        self.phoneNumber = phoneNumber
    }
    
    
}

//TODO: 데이터 작업
extension ContactsInfo{
    static let sampleData: [ContactsInfo] = [
        ContactsInfo(name: "Alex", phoneNumber: "010-1111-2222"),
        ContactsInfo(name: "Alex", phoneNumber: "010-1111-2222"),
        ContactsInfo(name: "Alex", phoneNumber: "010-1111-2222"),
        ContactsInfo(name: "Alex", phoneNumber: "010-1111-2222")
    ]
}
