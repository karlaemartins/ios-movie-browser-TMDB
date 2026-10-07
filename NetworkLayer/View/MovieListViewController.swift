//
//  MovieListViewController.swift
//  NetworkLayer
//
//  Created by Karla E. Martins Fernandes on 07/07/25.
//

import UIKit

class MovieListViewController: UIViewController {
    
    private let imageLoader: ImageLoading
    private let viewModel: MovieListViewModel
    
    var onMovieSelected: ((Movie, String) -> Void)?
    var onFavoritesSelected: (() -> Void)?
    
    private let tableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.rowHeight = 136
        tv.register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.reuseIdentifier)
        return tv
    }()
    
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private let emptyStateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Nenhum filme encontrado."
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        return label
    }()
    
    init(imageLoader: ImageLoading, viewModel: MovieListViewModel) {
        self.imageLoader = imageLoader
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) não foi implementado")
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.backButtonTitle = ""
        setupTableView()
        configureNavigationBar()
        
        viewModel.onStateChange = { [weak self] state in
               DispatchQueue.main.async {
                   self?.render(state: state)
               }
           }
        
        fetchMovies()
    }
    
    private func configureNavigationBar() {
        navigationItem.title = "Filmes"

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "heart"),
            style: .plain,
            target: self,
            action: #selector(didTapFavorites)
        )

        navigationItem.rightBarButtonItem?.tintColor = .label
    }
    
    @objc
    private func didTapFavorites() {
        onFavoritesSelected?()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        view.addSubview(loadingIndicator)
        view.addSubview(emptyStateLabel)
        tableView.dataSource = self
        tableView.delegate = self
        
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
    
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            emptyStateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyStateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            emptyStateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
        ])
    }
    
    private func fetchMovies() {
        viewModel.fetchData {}
    }
    
    private func render(state: ViewState) {
        switch state {
        case .idle:
            break

        case .loading:
            emptyStateLabel.isHidden = true
            loadingIndicator.startAnimating()

        case .loaded:
            loadingIndicator.stopAnimating()
            emptyStateLabel.isHidden = true
            tableView.reloadData()

        case .empty:
            loadingIndicator.stopAnimating()
            emptyStateLabel.isHidden = false

        case .error(let message):
            loadingIndicator.stopAnimating()
            emptyStateLabel.isHidden = true
            showError(message)
        }
    }
    
    private func showError(_ message: String) {
        let alert = UIAlertController(
            title: "Erro",
            message: message,
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "OK", style: .default))

        present(alert, animated: true)
    }
}

//Configurações da tabela com UITableViewDataSource
extension MovieListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfMovies
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.reuseIdentifier, for: indexPath) as? MovieTableViewCell else {
            return UITableViewCell()
        }
        
        let movie = viewModel.movie(at: indexPath.row)
        let genres = viewModel.genreNames(for: movie).joined(separator: ", ")
        cell.configure(with: movie, genreNames: genres, imageLoader: imageLoader)
        cell.accessoryType = .disclosureIndicator
        return cell
        
    }
}

//funçao para o clique da célula
extension MovieListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let movie = viewModel.movie(at: indexPath.row)
        let genres = viewModel.genreNames(for: movie).joined(separator: ", ")
        onMovieSelected?(movie, genres)
    }
    
}

