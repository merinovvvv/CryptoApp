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
        loadImage()
    }
    
    //MARK: - Methods
    func loadImage() {
        guard let url = coin.logoURL else {
            onImageLoaded?(UIImage(systemName: "questionmark"))
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data else { return }
            DispatchQueue.main.async {
                self?.onImageLoaded?(UIImage(data: data))
            }
        }.resume()
    }
    
    //MARK: - Computed Properties
    var rankLabelText: String {
        return "Rank: \(coin.rank)"
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
