//
//  CoinCell.swift
//  CryptoApp
//
//  Created by Yaroslav Merinov on 19.07.25.
//

import UIKit

final class CoinCell: UITableViewCell {
    
    //MARK: - Variables
    static let identifier: String = "CoinCell"
    private var viewModel: CoinCellViewModel?
    
    //MARK: - Constants
    private enum Constants {
        static let multiplier: CGFloat = 0.75
        static let leadingSpacing: CGFloat = 16.0
        static let coinNameSize: CGFloat = 22.0
    }
    
    //MARK: - UI Components
    private let coinLogo: UIImageView = UIImageView()
    private let coinName: UILabel = UILabel()
    
    
    //MARK: - LifeCycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.coinLogo.image = nil
        self.coinName.text = nil
        viewModel?.onImageLoaded = nil
        viewModel = nil
    }
    
    func configure(with coin: Coin) {
        viewModel = CoinCellViewModel(coin: coin)
        coinName.text = viewModel?.coinName
        
        viewModel?.onImageLoaded = { [weak self] image in
            DispatchQueue.main.async {
                self?.coinLogo.image = image
            }
        }
        
        viewModel?.loadImage()
    }
}

//MARK: - Setup UI
private extension CoinCell {
    func setupUI() {
        setupViewHierarchy()
        setupConstraints()
        configureViews()
    }
    
    func setupViewHierarchy() {
        contentView.addSubview(coinLogo)
        contentView.addSubview(coinName)
    }
    
    func setupConstraints() {
        coinLogo.translatesAutoresizingMaskIntoConstraints = false
        coinName.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            coinLogo.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            coinLogo.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            coinLogo.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: Constants.multiplier),
            coinLogo.widthAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: Constants.multiplier),
            
            coinName.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            coinName.leadingAnchor.constraint(equalTo: coinLogo.trailingAnchor, constant: Constants.leadingSpacing)
        ])
    }
    
    func configureViews() {
        coinName.font = .systemFont(ofSize: Constants.coinNameSize, weight: .semibold)
        coinName.textColor = .label
        coinName.textAlignment = .left
        
        coinLogo.contentMode = .scaleAspectFit
        coinLogo.clipsToBounds = true
    }
}
