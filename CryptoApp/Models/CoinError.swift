//
//  CoinError.swift
//  CryptoApp
//
//  Created by Yaroslav Merinov on 21.07.25.
//

import Foundation

// MARK: - CoinError
struct CoinError: Decodable {
    let status: Status
}

// MARK: - Status
struct Status: Decodable {
    let errorCode: Int
    let errorMessage: String

    enum CodingKeys: String, CodingKey {
        case errorCode = "error_code"
        case errorMessage = "error_message"
    }
}
