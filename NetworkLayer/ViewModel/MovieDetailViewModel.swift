//
//  MovieDetailViewModel.swift
//  NetworkLayer
//
//  Created by Karla E. Martins Fernandes on 13/07/26.
//

import Foundation

final class MovieDetailViewModel {

    private let apiKey = Secrets.apiKey
    private let language = "pt-BR"
    private let genres: String

    private(set) var movie: Movie
    private(set) var movieDetail: MovieDetail?
   

    init(movie: Movie, genres: String) {
        self.movie = movie
        self.genres = genres
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
    
    
    
    func fetchMovieDetails(completion: @escaping () -> Void) {

        let endpoint = Services.movieDetails(
            id: movie.id,
            apiKey: apiKey,
            language: language
        )

        NetworkRequest.instance.dispatch(
            endPoint: endpoint,
            tipo: MovieDetail.self
        ) { [weak self] response, _, error in

            if let error = error {
                print("Erro ao buscar detalhes: \(error.localizedDescription)")
                completion()
                return
            }

            self?.movieDetail = response
            completion()
        }
    }
    
    
}
