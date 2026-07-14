//
//  MovieListViewController.swift
//  NetworkLayer
//
//  Created by Karla E. Martins Fernandes on 07/07/25.
//

import UIKit

class MovieListViewController: UIViewController {
    
    private let viewModel = MovieListViewModel()
    
    var onMovieSelected: ((Movie, String) -> Void)?
    var onFavoritesSelected: (() -> Void)?
    
    private let tableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.rowHeight = 136
        tv.register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.reuseIdentifier)
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.backButtonTitle = ""
        setupTableView()
        configureNavigationBar()
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
        tableView.dataSource = self
        tableView.delegate = self
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func fetchMovies() {
        viewModel.fetchData {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}

//Configurações da tabela com UITableViewDataSource
extension MovieListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.popularMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.reuseIdentifier, for: indexPath) as? MovieTableViewCell else {
            return UITableViewCell()
        }
        
        let movie = viewModel.popularMovies[indexPath.row]
        let genres = viewModel.genreNames(for: movie).joined(separator: ", ")
        cell.configure(with: movie, genreNames: genres)
        cell.accessoryType = .disclosureIndicator
        return cell
        
    }
}

//funçao para o clique da célula
extension MovieListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = viewModel.popularMovies[indexPath.row]
        let genres = viewModel.genreNames(for: movie).joined(separator: ", ")
        onMovieSelected?(movie, genres)
    }
    
}

