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
        
        let cacheKey = url.absoluteString as NSString
        if let cachedImage = CacheManager.shared.image(for: cacheKey as String) {
            onImageLoaded?(cachedImage)
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let strongSelf = self,
                  let data = data,
                  let image = UIImage(data: data) else {
                DispatchQueue.main.async {
                    self?.onImageLoaded?(UIImage(systemName: "questionmark"))
                }
                return
            }
            
            CacheManager.shared.setImage(image, forKey: cacheKey as String)
            
            DispatchQueue.main.async {
                strongSelf.onImageLoaded?(image)
            }
        }.resume()
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
