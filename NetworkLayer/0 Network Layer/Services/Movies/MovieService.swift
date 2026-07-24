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
    
    func fetchMovieDetails(
        movieID: Int,
        completion: @escaping (Result<MovieDetail, Error>) -> Void
    ) {

        let endpoint = Services.movieDetails(
            id: movieID,
            apiKey: Secrets.apiKey,
            language: "pt-BR"
        )

        network.dispatch(
            endPoint: endpoint,
            tipo: MovieDetail.self
        ) { response, _, error in

            if let error = error {
                completion(.failure(error))
                return
            }

            guard let response else {
                completion(.failure(NSError(
                    domain: "MovieService",
                    code: -1,
                    userInfo: [
                        NSLocalizedDescriptionKey: "Resposta inválida."
                    ]
                )))
                return
            }

            completion(.success(response))
        }
    }
}
