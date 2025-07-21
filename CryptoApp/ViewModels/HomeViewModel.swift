//
//  HomeViewModel.swift
//  CryptoApp
//
//  Created by Yaroslav Merinov on 22.07.25.
//

final class HomeViewModel {
    var onCoinsUpdated: (() -> Void)?
    var onErrorMessage: ((CoinServiceError) -> Void)?
    
    private(set) var coins: [Coin] = [] {
        didSet {
            self.onCoinsUpdated?()
        }
    }
    
    init() {
        self.fetchData()
    }
    
    private func fetchData() {
        let endpoint = Endpoint.fetchCoins()
        
        CoinService.fetchCoins(with: endpoint) { [weak self] result in
            switch result {
            case .success(let coins):
                self?.coins = coins
                print("DEBUG PRINT: \(coins.count) coins fetched.")
            case .failure(let error):
                self?.onErrorMessage?(error)
            }
        }
    }
}
