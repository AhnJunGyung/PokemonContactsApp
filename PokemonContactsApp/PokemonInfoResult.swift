//
//  PokemonInfoResult.swift
//  PokemonContactsApp
//
//  Created by t2023-m0072 on 12/10/24.
//

import Foundation

struct Welcome: Codable {
    let id: Int
    let name: String
    let height, weight: Int
    let sprites: Sprites
}

struct Sprites: Codable {
    let frontDefault: String

    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
    }
}
