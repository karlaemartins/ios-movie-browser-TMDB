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
    
    private let emptyStateImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "heart")
        imageView.tintColor = .systemRed
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let emptyStateLabel: UILabel = {
        let label = UILabel()
        label.text = "Você ainda não possui\nfilmes favoritos.\n\nFavorite um filme para vê-lo aqui."
        label.font = .systemFont(ofSize: 18)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Favoritos"
        view.backgroundColor = .systemBackground

        setupTableView()
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        viewModel.loadFavorites()
        tableView.reloadData()
        updateEmptyState()
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
        view.addSubview(emptyStateImageView)
        view.addSubview(emptyStateLabel)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            emptyStateImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -40),
            emptyStateImageView.widthAnchor.constraint(equalToConstant: 60),
            emptyStateImageView.heightAnchor.constraint(equalToConstant: 60),

            emptyStateLabel.topAnchor.constraint(equalTo: emptyStateImageView.bottomAnchor, constant: 20),
            emptyStateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            emptyStateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)])
    }
    
    private func updateEmptyState() {
        let hasFavorites = viewModel.numberOfMovies > 0

        tableView.isHidden = !hasFavorites
        emptyStateImageView.isHidden = hasFavorites
        emptyStateLabel.isHidden = hasFavorites
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

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)

        let movie = viewModel.movie(at: indexPath.row)

        let detailVC = MovieDetailViewController(movie: movie, genres: "")

        navigationController?.pushViewController(detailVC, animated: true)
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let deleteAction = UIContextualAction(style: .destructive, title: "Remover") { [weak self] _, _, completion in

            guard let self = self else {
                completion(false)
                return
            }

            self.viewModel.removeFavorite(at: indexPath.row)

            tableView.deleteRows(at: [indexPath], with: .automatic)

            self.updateEmptyState()

            completion(true)
        }

        deleteAction.image = UIImage(systemName: "trash")

        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
