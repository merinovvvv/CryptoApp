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
        
        let urlString = url.absoluteString
        
        if CacheManager.shared.image(for: urlString) != nil {
            return
        }
        
        CacheManager.shared.loadImage(from: urlString) { [weak self] logo in
            self?.onImageLoaded?(logo)
        }
    }
    
    //MARK: - Computed Properties
    var coinName: String {
        return coin.name
    }
}
