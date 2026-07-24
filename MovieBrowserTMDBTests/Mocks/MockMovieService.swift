//
//  MockMovieService.swift
//  MovieBrowserTMDBTests
//
//  Created by Karla E. Martins Fernandes on 24/07/26.
//

import Foundation
@testable import NetworkLayer

final class MockMovieService: MovieServiceProtocol {

    var result: Result<MovieDetail, Error>?
    var fetchMovieDetailsCalled = false
    var receivedMovieID: Int?
    
    func fetchMovieDetails(
        movieID: Int,
        completion: @escaping (Result<MovieDetail, Error>) -> Void
    ) {
        
        fetchMovieDetailsCalled = true
        receivedMovieID = movieID
        
        if let result {
                completion(result)
            }
    }

}
