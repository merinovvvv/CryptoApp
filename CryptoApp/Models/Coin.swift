//
//  Coin.swift
//  CryptoApp
//
//  Created by Yaroslav Merinov on 20.07.25.
//

import Foundation

// MARK: - CoinArray
struct CoinArray: Decodable {
    let data: [Coin]
}

// MARK: - Coin
struct Coin: Decodable {
    let id: Int
    let name: String
    let maxSupply: Int?
    let rank: Int?
    let pricingData: PricingData
    
    var logoURL: URL? {
        return URL(string: "https://s2.coinmarketcap.com/static/img/coins/200x200/\(id).png")
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case maxSupply = "max_supply"
        case rank = "cmc_rank"
        case pricingData = "quote"
    }
}

// MARK: - PricingData
struct PricingData: Decodable {
    let USD: USD
}

// MARK: - USD
struct USD: Decodable {
    let price: Double
    let marketCap: Double
    
    enum CodingKeys: String, CodingKey {
        case price = "price"
        case marketCap = "market_cap"
    }
}
