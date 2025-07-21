//
//  Endpoint.swift
//  CryptoApp
//
//  Created by Yaroslav Merinov on 21.07.25.
//

import Foundation

enum Endpoint {
    case fetchCoins(url: String = "/v1/cryptocurrency/listings/latest")
    
    var request: URLRequest? {
        guard let url = self.url else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = self.httpMethod
        request.httpBody = self.httpBody
        request.addValues(for: self)
        return request
    }
    
    private var url: URL? {
        var components = URLComponents()
        components.scheme = Constants.scheme
        components.host = Constants.host
        components.port = Constants.port
        components.path = self.path
        components.queryItems = self.queryItems
        return components.url
    }
    
    private var path: String {
        switch self {
        case .fetchCoins(let url):
            return url
        }
    }
    
    private var httpMethod: String {
        switch self {
        case .fetchCoins:
            HTTP.Method.get.rawValue
        }
    }
    
    private var httpBody: Data? {
        switch self { case .fetchCoins: nil }
    }
    
    private var queryItems: [URLQueryItem] {
        switch self {
        case .fetchCoins:
            return [
                URLQueryItem(name: "limit", value: "150"),
                URLQueryItem(name: "sort", value: "market_cap"),
                URLQueryItem(name: "convert", value: "USD"),
                URLQueryItem(name: "aux", value: "cmc_rank,max_supply,circulating_supply,total_supply")
            ]
        }
    }
}

extension URLRequest {
    mutating func addValues(for endpoing: Endpoint) {
        switch endpoing {
        case .fetchCoins:
            self.setValue(Constants.API_KEY, forHTTPHeaderField: HTTP.Headers.Keys.apiKey.rawValue)
        }
    }
}
