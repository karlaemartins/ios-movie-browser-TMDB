//
//  MovieFavoritesViewController.swift
//  NetworkLayer
//
//  Created by Karla E. Martins Fernandes on 14/07/26.
//

import UIKit

class MovieFavoritesViewController: UIViewController {

    private let viewModel = MovieFavoritesViewModel()

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Favoritos"
        view.backgroundColor = .systemBackground

        setupTableView()
        viewModel.loadFavorites()
        setupLayout()
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self

        tableView.register(
            MovieTableViewCell.self,
            forCellReuseIdentifier: MovieTableViewCell.reuseIdentifier
        )
    }

    private func setupLayout() {
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension MovieFavoritesViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfMovies
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.reuseIdentifier, for: indexPath) as? MovieTableViewCell else {
            return UITableViewCell()
        }

        let movie = viewModel.movie(at: indexPath.row)

        cell.configure(with: movie, genreNames: "")

        return cell
    }
}

extension MovieFavoritesViewController: UITableViewDelegate {

}
