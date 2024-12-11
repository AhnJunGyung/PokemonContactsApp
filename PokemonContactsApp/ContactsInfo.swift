//
//  ContactsInfo.swift
//  PokemonContactsApp
//
//  Created by t2023-m0072 on 12/9/24.
//

import UIKit

struct ContactsInfo:Codable {
    
    var pokemonImage: String
    var name: String
    var phoneNumber: String
    
    init(name: String, phoneNumber: String, pokemonImage: String) {
        self.name = name
        self.phoneNumber = phoneNumber
        self.pokemonImage = pokemonImage
    }
    
    
}

