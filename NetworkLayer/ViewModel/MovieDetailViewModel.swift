//
//  MovieDetailViewModel.swift
//  NetworkLayer
//
//  Created by Karla E. Martins Fernandes on 13/07/26.
//

import Foundation

final class MovieDetailViewModel {

    private let genres: String
    private let favoritesStorage: FavoritesStorageProtocol
    private let movieService: MovieServiceProtocol

    private(set) var movie: Movie
    private(set) var movieDetail: MovieDetail?
   

    init(
        movie: Movie,
        genres: String,
        favoritesStorage: FavoritesStorageProtocol = FavoritesStorageService.shared,
        movieService: MovieServiceProtocol = MovieService()
    ) {
        self.movie = movie
        self.genres = genres
        self.favoritesStorage = favoritesStorage
        self.movieService = movieService
    }
    
    var title: String {
        movie.title
    }
    
    var info: String {
        "\(genres)\nLançamento: \(releaseYear)"
    }
    
    var releaseYear: String {
        String(movie.releaseDate?.prefix(4) ?? "N/A")
    }
    
    var overview: String {
        movie.overview ?? "Sem sinopse disponível."
    }
    
    var posterURL: URL? {
        guard let posterPath = movie.posterPath else { return nil }

        return URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")
    }
    
    var ratingText: String {
        guard let movieDetail else { return "⭐ --" }

        return "⭐ \(movieDetail.voteAverage)"
    }
    
    var runtimeText: String {
        guard let runtime = movieDetail?.runtime else {
            return "⏱️ --"
        }

        return "⏱️ \(runtime) min"
    }
    
    var languageText: String {
        guard let movieDetail else { return "🌍 --" }

        return "🌍 \(movieDetail.originalLanguage.uppercased())"
    }
    
    var isFavorite: Bool {
        favoritesStorage.isFavorite(movie)
    }

    func toggleFavorite() {
        if isFavorite {
            favoritesStorage.remove(movie)
        } else {
            favoritesStorage.save(movie)
        }
    }
    
    
    func fetchMovieDetails(completion: @escaping () -> Void) {

        movieService.fetchMovieDetails(movieID: movie.id) { [weak self] result in

            switch result {

            case .success(let movieDetail):
                self?.movieDetail = movieDetail

            case .failure(let error):
                print("Erro ao buscar detalhes: \(error.localizedDescription)")
            }

            completion()
        }
    }
    
    
}
