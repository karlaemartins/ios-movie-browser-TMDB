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

    private(set) var movie: Movie
    private(set) var movieDetail: MovieDetail?

    init(movie: Movie) {
        self.movie = movie
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
