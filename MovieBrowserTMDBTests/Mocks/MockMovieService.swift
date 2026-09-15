//
//  MockMovieService.swift
//  MovieBrowserTMDBTests
//
//  Created by Karla E. Martins Fernandes on 24/07/26.
//

import Foundation
@testable import NetworkLayer

final class MockMovieService: MovieServiceProtocol {

    // MARK: - Results
    
    var genresResult: Result<GenreResponse, NetworkError>?
    var popularMoviesResult: Result<MovieResponse, NetworkError>?
    var movieDetailsResult: Result<MovieDetail, NetworkError>?

    // MARK: - Calls
    
    var fetchGenresCalled = false
    var fetchPopularMoviesCalled = false
    var fetchMovieDetailsCalled = false
    
    // MARK: - Received Values
    
    var receivedPage: Int?
    var receivedMovieID: Int?
    
    // MARK: - Methods
    
    func fetchGenres(
        completion: @escaping (Result<GenreResponse, NetworkError>) -> Void
    ) {
        fetchGenresCalled = true
        
        if let genresResult {
            completion(genresResult)
        }
    }
    
    func fetchPopularMovies(
           page: Int,
           completion: @escaping (Result<MovieResponse, NetworkError>) -> Void
       ) {
           fetchPopularMoviesCalled = true
           receivedPage = page

           if let popularMoviesResult {
               completion(popularMoviesResult)
           }
       }
                

    func fetchMovieDetails(
        movieID: Int,
        completion: @escaping (Result<MovieDetail, NetworkError>) -> Void
    ) {
        fetchMovieDetailsCalled = true
        receivedMovieID = movieID

        if let movieDetailsResult {
            completion(movieDetailsResult)
        }
    }
}
