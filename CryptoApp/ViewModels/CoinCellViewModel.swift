//
//  CoinCellViewModel.swift
//  CryptoApp
//
//  Created by Yaroslav Merinov on 23.07.25.
//

import UIKit

final class CoinCellViewModel {
    
    //MARK: - Variables
    private let coin: Coin
    var onImageLoaded: ((UIImage?) -> Void)?
    
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
        
        let cacheKey = url.absoluteString
        if let cachedImage = CacheManager.shared.image(for: cacheKey) {
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
            
            CacheManager.shared.setImage(image, forKey: cacheKey)
            
            DispatchQueue.main.async {
                strongSelf.onImageLoaded?(image)
            }
        }.resume()
    }
    
    //MARK: - Computed Properties
    var coinName: String {
        return coin.name
    }
}
