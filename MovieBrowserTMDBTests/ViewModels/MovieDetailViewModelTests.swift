//
//  MovieDetailViewModelTests.swift
//  MovieBrowserTMDBTests
//
//  Created by Karla E. Martins Fernandes on 20/07/26.
//

import XCTest
@testable import NetworkLayer

private enum TestError: Error {
    case someError
}

final class MovieDetailViewModelTests: XCTestCase {

    // MARK: - Properties

    private var mockStorage: MockFavoritesStorage!
    private var mockMovieService: MockMovieService!
    private var sut: MovieDetailViewModel!

    // MARK: - Lifecycle

    override func setUp() {
        super.setUp()

        mockStorage = MockFavoritesStorage()
        mockMovieService = MockMovieService()
    }

    // MARK: - Tests Favorites
    
    func testIsFavoriteReturnsTrueWhenMovieIsFavorite() {

        //Arrange
        let movie = MovieFixture.makeMovie()

        mockStorage.favoriteMovies = [movie]

        sut = MovieDetailViewModel(
            movie: movie,
            genres: "Fantasia",
            favoritesStorage: mockStorage
        )

        //Assert
        XCTAssertTrue(sut.isFavorite)
    }
    
    func testIsFavoriteReturnsFalseWhenMovieIsNotFavorite() {
        
        //Arrange
        let movie = MovieFixture.makeMovie()

        mockStorage.favoriteMovies = []

        sut = MovieDetailViewModel(
            movie: movie,
            genres: "Fantasia",
            favoritesStorage: mockStorage
        )

        //Assert
        XCTAssertFalse(sut.isFavorite)
        
    }
    
    func testToggleFavoriteSavesMovieWhenMovieIsNotFavorite() {

        //Arrange
        let movie = MovieFixture.makeMovie()

        sut = MovieDetailViewModel(
            movie: movie,
            genres: "Fantasia",
            favoritesStorage: mockStorage
        )

        //Act
        sut.toggleFavorite()

        //Assert
        XCTAssertTrue(mockStorage.saveCalled)
        XCTAssertTrue(mockStorage.isFavorite(movie))
    }
    
    func testToggleFavoriteRemovesMovieWhenMovieIsFavorite() {
        
        //Arrange
        let movie = MovieFixture.makeMovie()

        mockStorage.favoriteMovies = [movie]

        sut = MovieDetailViewModel(
            movie: movie,
            genres: "Fantasia",
            favoritesStorage: mockStorage
        )
        
        //Act
        sut.toggleFavorite()
        
        //Assert
        XCTAssertTrue(mockStorage.removeCalled)
        XCTAssertFalse(mockStorage.isFavorite(movie))
    }
    
    
    // MARK: - Tests Fetch Movie Details
    
    func testFetchMovieDetailsCallsMovieService() {

        //Arrange
        let movie = MovieFixture.makeMovie()

        sut = MovieDetailViewModel(
            movie: movie,
            genres: "",
            favoritesStorage: mockStorage,
            movieService: mockMovieService)
        
        //Act
        sut.fetchMovieDetails(completion: {})
        
        //Assert
        XCTAssertTrue(mockMovieService.fetchMovieDetailsCalled)
        XCTAssertEqual(mockMovieService.receivedMovieID, movie.id)
    }
    
    func testFetchMovieDetailsUpdatesMovieDetailOnSuccess() {

        //Arrange
        let movie = MovieFixture.makeMovie()
        let movieDetail = MovieFixture.makeMovieDetail()

        mockMovieService.result = .success(movieDetail)

        sut = MovieDetailViewModel(
            movie: movie,
            genres: "",
            favoritesStorage: mockStorage,
            movieService: mockMovieService
        )

        //Act
        sut.fetchMovieDetails(completion: {})

        //Assert
        XCTAssertEqual(sut.movieDetail, movieDetail)
    }
    
    func testFetchMovieDetailsDoesNotUpdateMovieDetailOnFailure() {

        //Arrange
        let movie = MovieFixture.makeMovie()

        mockMovieService.result = .failure(TestError.someError)

        sut = MovieDetailViewModel(
            movie: movie,
            genres: "",
            favoritesStorage: mockStorage,
            movieService: mockMovieService
        )

        //Act
        sut.fetchMovieDetails(completion: {})

        //Assert
        XCTAssertNil(sut.movieDetail)
    }
    
    func testFetchMovieDetailsCallsCompletion() {

        //Arrange
        let movie = MovieFixture.makeMovie()
        let movieDetail = MovieFixture.makeMovieDetail()

        mockMovieService.result = .success(movieDetail)

        sut = MovieDetailViewModel(
            movie: movie,
            genres: "",
            favoritesStorage: mockStorage,
            movieService: mockMovieService
        )

        let expectation = expectation(description: "Completion should be called")

        //Act
        sut.fetchMovieDetails {
            expectation.fulfill()
        }

        //Assert
        wait(for: [expectation], timeout: 1.0)
    }

}
