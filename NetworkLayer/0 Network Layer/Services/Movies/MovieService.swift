//
//  MovieService.swift
//  NetworkLayer
//
//  Created by Karla E. Martins Fernandes on 24/07/26.
//

import Foundation

final class MovieService: MovieServiceProtocol {

    private let network: NetworkDispatch

        init(network: NetworkDispatch = NetworkRequest.instance) {
            self.network = network
        }
    
    func fetchGenres(
        completion: @escaping (Result<GenreResponse, NetworkError>) -> Void
    ) {
        let endpoint = Services.genres(
            apiKey: Secrets.apiKey,
            language: "pt-BR"
        )

        network.dispatch(
            endPoint: endpoint,
            tipo: GenreResponse.self,
            resposta: completion
        )
    }
    
    func fetchPopularMovies(
        page: Int = 1,
        completion: @escaping (Result<MovieResponse, NetworkError>) -> Void
    ) {
        let endpoint = Services.popularMovies(
            apiKey: Secrets.apiKey,
            language: "pt-BR",
            page: page
        )

        network.dispatch(
            endPoint: endpoint,
            tipo: MovieResponse.self,
            resposta: completion
        )
    }
    
    func fetchMovieDetails(
        movieID: Int,
        completion: @escaping (Result<MovieDetail, NetworkError>) -> Void
    ) {

        let endpoint = Services.movieDetails(
            id: movieID,
            apiKey: Secrets.apiKey,
            language: "pt-BR"
        )

        network.dispatch(
            endPoint: endpoint,
            tipo: MovieDetail.self,
            resposta: completion
        )
    }
}
