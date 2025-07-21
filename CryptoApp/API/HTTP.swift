//
//  HTTP.swift
//  CryptoApp
//
//  Created by Yaroslav Merinov on 21.07.25.
//

enum HTTP {
    enum Method: String {
        case get = "GET"
    }
    
    enum Headers {
        enum Keys: String {
            case apiKey = "X-CMC_PRO_API_KEY"
        }
    }
}
