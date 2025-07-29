//
//  CoinViewModel.swift
//  CryptoApp
//
//  Created by Yaroslav Merinov on 20.07.25.
//

import UIKit

final class CoinViewModel {
    
    //MARK: - Variables
    let coin: Coin
    var onImageLoaded: ((UIImage?) -> Void)?
    
    //MARK: - Constants
    
    //MARK: - Initializer
    init(coin: Coin) {
        self.coin = coin
    }
    
    //MARK: - Methods
    func loadImage() {
        guard let url = coin.logoURL else {
            onImageLoaded?(UIImage(systemName: "questionmark"))
            return
        }
        
        CacheManager.shared.loadImage(from: url.absoluteString) { [weak self] image in
            DispatchQueue.main.async {
                self?.onImageLoaded?(image)
            }
        }
    }
    
    //MARK: - Computed Properties
    var rankLabelText: String {
        guard let rank = coin.rank else { return "" }
        return "Rank: \(rank)"
    }
    
    var priceLabelText: String {
        return "Price: $\(coin.pricingData.USD.price) USD"
    }
    
    var marketCapLabelText: String {
        return "Market Cap: $\(coin.pricingData.USD.marketCap) USD"
    }
    
    var maxSupplyLabelText: String {
        if let maxSupply = coin.maxSupply {
            return "Max Supply: \(maxSupply)"
        } else {
            return "scroll test\nscroll test\nscroll test\nscroll test\nscroll test\nscroll test\nscroll test\nscroll test\nscroll test\nscroll test\nscroll test\nscroll test\nscroll test\nscroll test\nscroll test\nscroll test\nscroll test\nscroll test\n"
        }
    }
}
