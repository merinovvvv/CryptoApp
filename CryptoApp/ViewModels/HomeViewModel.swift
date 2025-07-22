//
//  HomeViewModel.swift
//  CryptoApp
//
//  Created by Yaroslav Merinov on 22.07.25.
//

import Foundation

final class HomeViewModel {
    
    var onCoinsUpdated: (() -> Void)?
    var onErrorMessage: ((CoinServiceError) -> Void)?
    private var inSearchMode: Bool = false
    private var searchWorkItem: DispatchWorkItem?
    
    var coins: [Coin] {
        return inSearchMode ? filteredCoins : allCoins
    }
    
    private(set) var allCoins: [Coin] = [] {
        didSet {
            self.onCoinsUpdated?()
        }
    }
    
    private(set) var filteredCoins: [Coin] = []
    
    init() {
        self.fetchData()
    }
    
    private func fetchData() {
        let endpoint = Endpoint.fetchCoins()
        
        CoinService.fetchCoins(with: endpoint) { [weak self] result in
            switch result {
            case .success(let coins):
                self?.allCoins = coins
                print("DEBUG PRINT: \(coins.count) coins fetched.")
            case .failure(let error):
                self?.onErrorMessage?(error)
            }
        }
    }
}

extension HomeViewModel {
    public func setInSearchMode(isSearchControllerActive: Bool, searchBarText: String?) {
        let text = searchBarText ?? ""
        inSearchMode = isSearchControllerActive && !text.isEmpty
    }
    
    public func updateSearchController(searchBarText: String?) {
        searchWorkItem?.cancel()
        
        searchWorkItem = DispatchWorkItem { [weak self] in
            guard let strongSelf = self else { return }
            
            strongSelf.filteredCoins = strongSelf.allCoins
            
            if let searchText = searchBarText?.lowercased(), !searchText.isEmpty {
                strongSelf.filteredCoins = strongSelf.filteredCoins.filter {
                    $0.name.lowercased().contains(searchText)
                }
            }
            
            strongSelf.onCoinsUpdated?()
        }
        
        if let workItem = searchWorkItem {
            DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 0.3, execute: workItem)
        }
    }
}
