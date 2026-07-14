//
//  MovieTableViewCell.swift
//  NetworkLayer
//
//  Created by Karla E. Martins Fernandes on 09/09/25.
//

import UIKit

class MovieTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "MovieTableViewCell"
    
    //Subviews
    let posterImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.layer.cornerRadius = 8
        return iv
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let detailsLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .darkGray
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let infoStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 4
        stack.alignment = .leading
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()

        posterImageView.image = UIImage(systemName: "photo")
    }
    
    //Layout
    private func setupLayout() {
        contentView.addSubview(posterImageView)
        contentView.addSubview(infoStack)
        
        infoStack.addArrangedSubview(titleLabel)
        infoStack.addArrangedSubview(detailsLabel)
        
        NSLayoutConstraint.activate([
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            posterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            posterImageView.widthAnchor.constraint(equalToConstant: 80),
            posterImageView.heightAnchor.constraint(equalToConstant: 120),
            
            infoStack.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 12),
            infoStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            infoStack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    //Configurações
    func configure(with movie: Movie, genreNames: String) {
        titleLabel.text = movie.title
        let year = movie.releaseDate?.prefix(4) ?? "N/A"
        detailsLabel.text = "\(genreNames) | \(year)"
        
        // Carregamento da imagem do pôster
        posterImageView.image = UIImage(systemName: "photo")

        guard let path = movie.posterPath else { return }

        guard let url = URL(string: "https://image.tmdb.org/t/p/w200\(path)") else { return }

        ImageLoader.shared.loadImage(from: url) { [weak self] image in
            self?.posterImageView.image = image
        }
    }
}
