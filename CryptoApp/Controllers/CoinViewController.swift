//
//  CoinViewController.swift
//  CryptoApp
//
//  Created by Yaroslav Merinov on 19.07.25.
//

import UIKit

class CoinViewController: UIViewController {
    
    //MARK: - Variables
    var viewModel: CoinViewModel
    
    //MARK: - Constants
    private enum Constants {
        static let imageSize: CGSize = CGSize(width: 200.0, height: 200.0)
        static let topSpacing: CGFloat = 20.0
        static let stackSpacing: CGFloat = 12.0
        static let labelSize: CGFloat = 20.0
        static let maxSupplyNumberOfLines: Int = 500
    }
    
    //MARK: - UI Components
    private let scrollView: UIScrollView = UIScrollView()
    private let contentView: UIView = UIView()
    
    private let coinLogo: UIImageView = UIImageView()
    private let labelStack: UIStackView = UIStackView()
    private let rankLabel: UILabel = UILabel()
    private let priceLabel: UILabel = UILabel()
    private let marketCapLabel: UILabel = UILabel()
    private let maxSupplyLabel: UILabel = UILabel()
    
    //MARK: - LifeCycle
    init(viewModel: CoinViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.title = viewModel.coin.name
        navigationController?.navigationBar.topItem?.backBarButtonItem? = UIBarButtonItem(title: "Back", style: .done, target: nil, action: nil)
        setupUI()
    }
}

//MARK: - Setup UI
private extension CoinViewController {
    func setupUI() {
        setupViewHierarchy()
        setupConstraints()
        configureViews()
    }
    
    func setupViewHierarchy() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(coinLogo)
        contentView.addSubview(labelStack)
        labelStack.addArrangedSubview(rankLabel)
        labelStack.addArrangedSubview(priceLabel)
        labelStack.addArrangedSubview(marketCapLabel)
        labelStack.addArrangedSubview(maxSupplyLabel)
    }
    
    func setupConstraints() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        coinLogo.translatesAutoresizingMaskIntoConstraints = false
        labelStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            coinLogo.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            coinLogo.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.topSpacing),
            coinLogo.heightAnchor.constraint(equalToConstant: Constants.imageSize.height),
            coinLogo.widthAnchor.constraint(equalToConstant: Constants.imageSize.width),
            
            labelStack.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            labelStack.topAnchor.constraint(equalTo: coinLogo.bottomAnchor, constant: Constants.topSpacing),
            labelStack.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor),
            labelStack.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor),
            
            labelStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.topSpacing)
        ])
    }
    
    func configureViews() {
        viewModel.onImageLoaded = { [weak self] logoImage in
            DispatchQueue.main.async {
                self?.coinLogo.image = logoImage
            }
        }
        
        labelStack.axis = .vertical
        labelStack.spacing = Constants.stackSpacing
        labelStack.alignment = .center
        labelStack.distribution = .fill
        
        rankLabel.text = viewModel.rankLabelText
        rankLabel.font = UIFont.systemFont(ofSize: Constants.labelSize, weight: .semibold)
        rankLabel.textAlignment = .center
        rankLabel.textColor = .label
        
        priceLabel.text = viewModel.priceLabelText
        priceLabel.font = UIFont.systemFont(ofSize: Constants.labelSize, weight: .semibold)
        priceLabel.textAlignment = .center
        priceLabel.textColor = .label
        
        marketCapLabel.text = viewModel.marketCapLabelText
        marketCapLabel.font = UIFont.systemFont(ofSize: Constants.labelSize, weight: .semibold)
        marketCapLabel.textAlignment = .center
        marketCapLabel.textColor = .label
        
        maxSupplyLabel.text = viewModel.maxSupplyLabelText
        maxSupplyLabel.font = UIFont.systemFont(ofSize: Constants.labelSize, weight: .semibold)
        maxSupplyLabel.textAlignment = .center
        maxSupplyLabel.textColor = .label
        maxSupplyLabel.numberOfLines = Constants.maxSupplyNumberOfLines
    }
}
