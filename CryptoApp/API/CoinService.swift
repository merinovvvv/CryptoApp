//
//  CoinService.swift
//  CryptoApp
//
//  Created by Yaroslav Merinov on 22.07.25.
//

import Foundation

enum CoinServiceError: Error {
    case serverError(CoinError)
    case unknown(String = "An unknown error occured.")
    case decodingError(String = "Error parsing server response")
}

final class CoinService {
    static func fetchCoins(with endpoint: Endpoint, completion: @escaping (Result<[Coin], CoinServiceError>) -> Void) {
        guard let request = endpoint.request else { return }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.unknown(error.localizedDescription)))
                return
            }
            
            if let response = response as? HTTPURLResponse,
               response.statusCode != 200 {
                do {
                    let coinError = try JSONDecoder().decode(CoinError.self, from: data ?? Data())
                    completion(.failure(.serverError(coinError)))
                } catch {
                    completion(.failure(.unknown()))
                }
                
            }
            
            if let data = data {
                do {
                    let coinsData = try JSONDecoder().decode(CoinArray.self, from: data)
                    completion(.success(coinsData.data))
                } catch {
                    completion(.failure(.decodingError(error.localizedDescription)))
                }
                
            } else {
                completion(.failure(.unknown()))
            }
        }.resume()
    }
}
