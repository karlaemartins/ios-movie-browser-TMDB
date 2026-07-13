//
//  MovieDetailViewController.swift
//  NetworkLayer
//
//  Created by Karla E. Martins Fernandes on 13/09/25.
//

import UIKit

class MovieDetailViewController: UIViewController {

    private let viewModel: MovieDetailViewModel

    private let posterImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.layer.cornerRadius = 8
        return iv
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 22)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let infoLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .darkGray
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .darkGray
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let runtimeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .darkGray
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let languageLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .darkGray
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let detailsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 20
        stack.distribution = .fillEqually
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private let overviewLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .darkGray
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    init(movie: Movie, genres: String) {
        self.viewModel = MovieDetailViewModel(movie: movie, genres: genres)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) não foi implementado")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        setupLayout()
        configure()
        fetchMovieDetails()
    }

    private func setupLayout() {

        detailsStackView.addArrangedSubview(ratingLabel)
        detailsStackView.addArrangedSubview(runtimeLabel)
        detailsStackView.addArrangedSubview(languageLabel)

        view.addSubview(posterImageView)
        view.addSubview(titleLabel)
        view.addSubview(infoLabel)
        view.addSubview(detailsStackView)
        view.addSubview(overviewLabel)

        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            posterImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            posterImageView.widthAnchor.constraint(equalToConstant: 200),
            posterImageView.heightAnchor.constraint(equalToConstant: 300),

            titleLabel.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            infoLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            infoLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            infoLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            detailsStackView.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 14),
            detailsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 14),
            detailsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -14),

            overviewLabel.topAnchor.constraint(equalTo: detailsStackView.bottomAnchor, constant: 16),
            overviewLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            overviewLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }

    private func configure() {
        titleLabel.text = viewModel.title
        infoLabel.text = viewModel.info

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .justified

        let attributedString = NSAttributedString(
            string: viewModel.overview,
            attributes: [.paragraphStyle: paragraphStyle]
        )

        overviewLabel.attributedText = attributedString

        posterImageView.image = UIImage(systemName: "photo")

        guard let url = viewModel.posterURL else { return }

        ImageLoader.shared.loadImage(from: url) { [weak self] image in
            self?.posterImageView.image = image
        }
    }

    private func fetchMovieDetails() {
        viewModel.fetchMovieDetails { [weak self] in
            DispatchQueue.main.async {
                self?.updateMovieDetails()
            }
        }
    }

    private func updateMovieDetails() {
        ratingLabel.text = viewModel.ratingText
        runtimeLabel.text = viewModel.runtimeText
        languageLabel.text = viewModel.languageText
    }
}
