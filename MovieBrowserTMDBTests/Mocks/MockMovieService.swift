//
//  MockMovieService.swift
//  MovieBrowserTMDBTests
//
//  Created by Karla E. Martins Fernandes on 24/07/26.
//

import Foundation
@testable import NetworkLayer

final class MockMovieService: MovieServiceProtocol {

    var result: Result<MovieDetail, NetworkError>?

    var fetchMovieDetailsCalled = false
    var receivedMovieID: Int?

    func fetchMovieDetails(
        movieID: Int,
        completion: @escaping (Result<MovieDetail, NetworkError>) -> Void
    ) {
        fetchMovieDetailsCalled = true
        receivedMovieID = movieID

        if let result {
            completion(result)
        }
    }

    func fetchGenres(
        completion: @escaping (Result<GenreResponse, NetworkError>) -> Void
    ) {
    }

    func fetchPopularMovies(
        page: Int,
        completion: @escaping (Result<MovieResponse, NetworkError>) -> Void
    ) {
    }
}
