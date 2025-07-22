//
//  HomeViewController.swift
//  CryptoApp
//
//  Created by Yaroslav Merinov on 18.07.25.
//

import UIKit

final class HomeViewController: UIViewController {
    
    //MARK: - Variables
    private let viewModel: HomeViewModel
    
    //MARK: - Constants
    private enum Constants {
        static let cellHeight: CGFloat = 88.0
    }
    
    //MARK: - UI Components
    private let tableView: UITableView = UITableView()
    private let searchController = UISearchController()
    
    //MARK: - LifeCycle
    
    init(viewModel: HomeViewModel = HomeViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.title = "CryptoApp"
        setupUI()
        setupSearchController()
        setupClosures()
    }
    
    private func setupSearchController() {
        self.searchController.searchResultsUpdater = self
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.searchBar.placeholder = "Search Cryptos"
        
        self.navigationItem.searchController = self.searchController
        self.definesPresentationContext = false
        self.navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func setupClosures() {
        viewModel.onCoinsUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        
        viewModel.onErrorMessage = { [weak self] error in
            
            DispatchQueue.main.async {
                let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
                
                switch error {
                case .serverError(let serverError):
                    alertController.title = "Server error: \(serverError.status.errorCode)"
                    alertController.message = serverError.status.errorMessage
                case .unknown(let unknownError):
                    alertController.title = "Error fetching coins"
                    alertController.message = unknownError
                case .decodingError(let decodingError):
                    alertController.title = "Error parsing data"
                    alertController.message = decodingError
                }
                
                self?.present(alertController, animated: true)
            }
        }
    }
}

//MARK: - SearchController
extension HomeViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        self.viewModel.setInSearchMode(isSearchControllerActive: searchController.isActive, searchBarText: searchController.searchBar.text)
        self.viewModel.updateSearchController(searchBarText: searchController.searchBar.text)
    }
    
    
}

//MARK: - Setup UI
private extension HomeViewController {
    func setupUI() {
        setupViewHierarchy()
        setupConstraints()
        configureViews()
    }
    
    func setupViewHierarchy() {
        view.addSubview(tableView)
    }
    
    func setupConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func configureViews() {
        tableView.register(CoinCell.self, forCellReuseIdentifier: CoinCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewModel.coins.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: CoinCell.identifier, for: indexPath) as? CoinCell {
            let coin = self.viewModel.coins[indexPath.row]
            cell.configure(with: coin)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        Constants.cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let coin = self.viewModel.coins[indexPath.row]
        let coinVC = CoinViewController(viewModel: CoinViewModel(coin: coin))
        self.navigationController?.pushViewController(coinVC, animated: true)
    }
}
